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
    
    func save(array: [[String: Any]], completion: @escaping (NSError?) -> Void)
    
}

final class PostStorage: IPostStorage {
    
    func save(array: [[String: Any]], completion: @escaping (NSError?) -> Void) {
        
//        DispatchQueue.global().async {
//            
//            for data in array {
//                
//                let cdPost = CDPost(context: Model.coreData.viewContext)
//                
//                cdPost.fill(data: data)
//                
//            }
//            
//            
//        }
        
    }
    
}
