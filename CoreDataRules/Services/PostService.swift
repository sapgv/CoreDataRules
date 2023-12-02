//
//  PostService.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import Foundation

protocol IPostService: AnyObject {
    
    func fetchPosts(completion: @escaping (Swift.Result<[[String: Any]], Error>) -> Void)
    
}

final class PostService: IPostService {
    
    func fetchPosts(completion: @escaping (Swift.Result<[[String: Any]], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            // Api request
            
            let array = PostData.array
            
            DispatchQueue.main.async {
                
                completion(.success(array))
                
            }
            
        }
        
    }
    
}
