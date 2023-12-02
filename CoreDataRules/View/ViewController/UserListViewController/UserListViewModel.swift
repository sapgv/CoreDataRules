//
//  UserListViewModel.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import Foundation

protocol IUserListViewModel: AnyObject {
    
    var updateCompletion: ((Error?) -> Void)? { get set }
    
    func update()
    
}

final class UserListViewModel: IUserListViewModel {
    
    var updateCompletion: ((Error?) -> Void)? = nil
    
    private let userService: IUserService
    
    private let userStorage: IUserStorage
    
    init(userService: IUserService = UserService(),
         userStorage: IUserStorage = UserStorage()) {
        self.userService = userService
        self.userStorage = userStorage
    }
    
    func update() {

        self.userService.fetchUsers { [weak self] result in
            
            switch result {
            case let .failure(error):
                self?.updateCompletion?(error)
            case let .success(array):
                self?.save(array: array)
            }
            
        }
        
    }
    
    private func save(array: [[String: Any]]) {
        
        self.userStorage.save(array: array) { [weak self] error in
         
            self?.updateCompletion?(error)
            
        }
        
    }
    
}
