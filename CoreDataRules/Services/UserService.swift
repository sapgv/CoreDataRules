//
//  UserService.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import Foundation

protocol IUserService: AnyObject {
    
    func fetchUsers(completion: @escaping (Swift.Result<[[String: Any]], Error>) -> Void)
    
}

final class UserService: IUserService {
    
    func fetchUsers(completion: @escaping (Swift.Result<[[String: Any]], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            // Api request
            
            Thread.sleep(forTimeInterval: 1)
            
            let array = UserData.array
            
            DispatchQueue.main.async {
                
                completion(.success(array))
                
            }
            
        }
        
    }
    
}
