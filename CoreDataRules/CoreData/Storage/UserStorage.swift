//
//  UserStorage.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import CoreData

protocol IUserStorage: AnyObject {
    
    func save(array: [[String: Any]], completion: @escaping (NSError?) -> Void)
    
}

final class UserStorage: IUserStorage {
    
    func save(array: [[String: Any]], completion: @escaping (NSError?) -> Void) {
        
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
        
    }
    
}
