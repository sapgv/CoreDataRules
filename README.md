# Core Data Rules

В этом приложении мы рассматриваем как правильно работать с Core Data

## Rules

### 1. Работайте с Core Data всегда в нужном контексте. 
Все что вы делает на главном потоке должно происходить на главном контексте `mainContext` или `viewContext`. Все что вы делаете или хотите сделать в бэкграунд потоке вы должны делать в `privateContext`

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
