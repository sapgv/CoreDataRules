# Core Data Rules

В этом приложении мы рассматриваем как правильно работать с Core Data

## Rules

### 1. Работайте с Core Data всегда в нужном контексте. 
Все что вы делает на главном потоке должно происходить на главном контексте `mainContext` или `viewContext`. Все что вы делаете или хотите сделать в бэкграунд потоке вы должны делать в `privateContext`

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
