//
//  PostStorage.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 17.11.2023.
//

import CoreData

enum StorageError: Error {
    
    case saveFailure(String)
    
}

protocol IPostStorage: AnyObject {
    
    func createPost(context: NSManagedObjectContext) -> CDPost
    
}

final class PostStorage: IPostStorage {
    
    func createPost(context: NSManagedObjectContext) -> CDPost {
        
        let cdPost = CDPost(context: context)
        cdPost.date = Date()
        
        return cdPost
        
    }
    
}
