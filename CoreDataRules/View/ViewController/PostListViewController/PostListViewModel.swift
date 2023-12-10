//
//  PostListViewModel.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import CoreData

protocol IPostListViewModel: AnyObject {
    
    var createPostCompletion: ((CDPost, NSManagedObjectContext) -> Void)? { get set }
    
    var editPostCompletion: ((CDPost, NSManagedObjectContext) -> Void)? { get set }
    
    var deletePostCompletion: ((NSError?) -> Void)? { get set }
    
    func createPost()
    
    func edit(cdPost: CDPost)
    
    func delete(cdPost: CDPost)
    
}

final class PostListViewModel: IPostListViewModel {
    
    var createPostCompletion: ((CDPost, NSManagedObjectContext) -> Void)?
    
    var editPostCompletion: ((CDPost, NSManagedObjectContext) -> Void)?
    
    var deletePostCompletion: ((NSError?) -> Void)?
    
    private let postStorage: IPostStorage
    
    init(postStorage: IPostStorage = PostStorage()) {
        self.postStorage = postStorage
    }
    
    func createPost() {
        
        self.postStorage.create { [weak self] cdPost, viewContext in
            
            self?.createPostCompletion?(cdPost, viewContext)
            
        }
        
    }
    
    func edit(cdPost: CDPost) {
        
        self.postStorage.edit(cdPost: cdPost) { [weak self] cdPost, viewContext in
            
            self?.editPostCompletion?(cdPost, viewContext)
            
        }
        
    }
    
    func delete(cdPost: CDPost) {
        
        self.postStorage.delete(cdPost: cdPost) { [weak self] error in
            
            self?.deletePostCompletion?(error)
            
        }
        
    }
    
}
