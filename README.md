# Core Data Rules

В этом приложении мы рассматриваем как правильно работать с Core Data

## Rules

### 1. Работайте с Core Data всегда в нужном контексте. 
Все что вы делаете на главном потоке должно происходить на главном контексте `mainContext` или `viewContext`. Все что вы делаете или хотите сделать в бэкграунд потоке вы должны делать в `privateContext`

Пример
```swift
Model.coreData.backgroundTask { privateContext in
            
    privateContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    
    for data in array {
        
        let cdUser = CDUser(context: privateContext)
        cdUser.fill(data: data)
        
    }
    
    Model.coreData.save(in: privateContext) { status in
        
        DispatchQueue.main.async {
            
            switch status {
            case .hasNoChanges, .saved:
                completion(nil)
            default:
                completion(StorageError.saveFailure(CDUser.entityName).NSError)
            }
            
        }
        
    }
            
}
```
В этом примере мы сделали `backgroundTask` и получили `privateContext`. Далее мы создаем пользователя на этом контексте, сохраняем и переходим на главный поток. 

### 2. В Core Data запрещено передавать объекты между контекстами напрямую

Допустим вы создали экран редактирования объекта с `viewContext`. На этом экране вы нажимаете кнопку и открывается новый экран список объектов для выбора на ваш экран. Допустим экран где список выбора тоже есть `viewContext` но это другой `viewContext`. Так вот запрещено передавать объект с разных контекстов напрямую. Вместо передачи самого объекта нужно передавать `objectID`.

Пример
```swift
func updateUser(cdUser: CDUser) {
        
    guard let cdUserInContext = self.viewContext.object(with: cdUser.objectID) as? CDUser else { return }

    self.cdPost.cdUser = cdUserInContext

    self.updateUserCompletion?()

}
```
В этом примере мы передали `CDUser` но мы не обращаемся к его свойствам и не присваиваем его как параметр как свойство `CDPost`. Вместо этого мы получаем `objectID` и воссоздаем объект на нужном нам контексте и только после этого мы можем присвоить пользователя для модели CDPost.

### 3. MergeConflict при сохранении

### 3.1 Когда вы сохранили что то в `privateContext` работая в это же время на `viewContext`

Предположим вы работаете на экране редактирования вашей модели `CDPost` и вы используете `viewContext`. В это время прилетел пуш и у вас где то сработал код и в `privateContext` обновил вашу модель `CDPost`.
В этом случае когда вы будете сохранить ваш `viewContext` у вас будет ошибка `Error Domain=App.NSError Code=0 "Could not merge changes." UserInfo={NSLocalizedDescription=Could not merge changes.}`

### Решение 1
Установить для вашего `viewContext` свойство `self.viewContext.automaticallyMergesChangesFromParent = true`. Тогда когда сохраниться `privateContext` все изменения обновятся на вашем `viewContext`.

### Решение 2 
Установить для вашего `viewContext` свойство `self.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump`. Тогда когда будет сохранятся `viewContext` то он перезапишет изменения сделанные на `privateContext`, при этом изменения на `privateContext` сохранятся если вы их не меняли на `viewContext`.

### Решение 3
Перед сохранением вашего `viewContext` нужно обновить контекст `self.viewContext.refreshAllObjects()` или `self.viewContext.refresh(self.cdPost, mergeChanges: true)` 

### 3.2 Когда вы сохранили что то в `privateContext` работая в это же время на `viewContext`. Тут есть дополнение когда вы сохранили используя `BatchResuest`.

```swift
Model.coreData.backgroundTask { privateContext in
            
            guard let cdPost = privateContext.object(with: cdPost.objectID) as? CDPost else { return }
            
            guard let id = cdPost.id else { return }
            
            let predicate = NSPredicate(format: "id == %@", id)
            
            let updateRequest = NSBatchUpdateRequest(entityName: CDPost.entityName)
            updateRequest.predicate = predicate
            updateRequest.propertiesToUpdate = ["mark": !cdPost.mark]
            updateRequest.resultType = .updatedObjectIDsResultType
            
            do {
                let results = try privateContext.execute(updateRequest) as! NSBatchUpdateResult
                let changes: [AnyHashable: Any] = [
                    NSUpdatedObjectsKey: results.result as! [NSManagedObjectID]
                ]
                
                completion(nil)
            } catch {
                completion(error.NSError)
            }
            
        }
```
### Решение 1 
Установить для вашего `viewContext` свойство `self.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump`. Тогда когда будет сохранятся `viewContext` то он перезапишет изменения сделанные на `privateContext`, при этом изменения на `privateContext` сохранятся если вы их не меняли на `viewContext`.

### Решение 2 
Когда вы делаете `BatchResuest` то это пишется сразу в базу данных миную `Notification` и `automaticallyMergesChangesFromParent` в этом случае на работает. Нужно сделать `Merge` вручную

```swift
Model.coreData.backgroundTask { privateContext in
            
            guard let cdPost = privateContext.object(with: cdPost.objectID) as? CDPost else { return }
            
            guard let id = cdPost.id else { return }
            
            let predicate = NSPredicate(format: "id == %@", id)
            
            let updateRequest = NSBatchUpdateRequest(entityName: CDPost.entityName)
            updateRequest.predicate = predicate
            updateRequest.propertiesToUpdate = ["mark": !cdPost.mark]
            updateRequest.resultType = .updatedObjectIDsResultType
            
            do {
                let results = try privateContext.execute(updateRequest) as! NSBatchUpdateResult
                let changes: [AnyHashable: Any] = [
                    NSUpdatedObjectsKey: results.result as! [NSManagedObjectID]
                ]
                if !contexts.isEmpty {
                    Log.debug("CoreData", "start merging")
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: contexts)
                    Log.debug("CoreData", "end merging")
                }
                completion(nil)
            } catch {
                completion(error.NSError)
            }
            
        }
```

Обратите тут внимание на код

```swift
if !contexts.isEmpty {
            Log.debug("CoreData", "start merging")
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: contexts)
            Log.debug("CoreData", "end merging")
}
```

Мы передаем массив контектов которые мы хотим уведомить об изменениям. В этом массиве должен быть наш `viewContext`. 
