//
//  UserStorage.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import Foundation

protocol IUserStorage: AnyObject {
    
    func save(array: [[String: Any]], completion: @escaping (NSError?) -> Void)
    
}

final class UserStorage: IUserStorage {
    
    func save(array: [[String: Any]], completion: @escaping (NSError?) -> Void) {
        
        
    }
    
}
