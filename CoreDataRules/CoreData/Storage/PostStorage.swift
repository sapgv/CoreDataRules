//
//  PostStorage.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 17.11.2023.
//

import CoreData

enum StorageError: Error {
    
    case saveFailure(String)
    case deleteFailure(String)
    
}

protocol IPostStorage: AnyObject {
    
    func create(completion: @escaping (CDPost, NSManagedObjectContext) -> Void)
    
    func edit(cdPost: CDPost, completion: @escaping (CDPost, NSManagedObjectContext) -> Void)
    
    func delete(cdPost: CDPost, completion: @escaping (NSError?) -> Void)
    
}

final class PostStorage: IPostStorage {
    
    func create(completion: @escaping (CDPost, NSManagedObjectContext) -> Void) {
        
        let viewContext = Model.coreData.createChildContextFromCoordinator(for: .mainQueueConcurrencyType)
        
        let cdPost = CDPost(context: viewContext)
        cdPost.date = Date()
        cdPost.id = UUID().uuidString
        
        completion(cdPost, viewContext)
        
    }
    
    func edit(cdPost: CDPost, completion: @escaping (CDPost, NSManagedObjectContext) -> Void) {
        
        let viewContext = Model.coreData.createChildContextFromCoordinator(for: .mainQueueConcurrencyType)

        guard let editPost = viewContext.object(with: cdPost.objectID) as? CDPost else { return }
        
        completion(editPost, viewContext)
        
    }
    
    func delete(cdPost: CDPost, completion: @escaping (NSError?) -> Void) {
        
        Model.coreData.backgroundTask { privateContext in
            
            guard let cdPost = privateContext.object(with: cdPost.objectID) as? CDPost else {
                DispatchQueue.main.async {
                    completion(StorageError.deleteFailure(CDPost.entityName).NSError)
                }
                return
            }
            
            Model.coreData.delete(cdPost, from: privateContext) { status in
                
                DispatchQueue.main.async {
                    
                    switch status {
                    case .hasNoChanges, .saved:
                        completion(nil)
                    default:
                        completion(StorageError.deleteFailure(CDPost.entityName).NSError)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
