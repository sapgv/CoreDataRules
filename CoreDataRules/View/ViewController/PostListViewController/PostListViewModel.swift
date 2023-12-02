//
//  PostListViewModel.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import CoreData

protocol IPostListViewModel: AnyObject {
    
    var createPostCompletion: ((CDPost, NSManagedObjectContext) -> Void)? { get set }
    
    func createPost()
    
}

final class PostListViewModel: IPostListViewModel {
    
    var createPostCompletion: ((CDPost, NSManagedObjectContext) -> Void)?
    
    private let postStorage: IPostStorage
    
    init(postStorage: IPostStorage = PostStorage()) {
        self.postStorage = postStorage
    }
    
    func createPost() {
        
        let viewContext = Model.coreData.createChildContextFromCoordinator(for: .mainQueueConcurrencyType)

        let cdPost = self.postStorage.createPost(context: viewContext)
        
        self.createPostCompletion?(cdPost, viewContext)
        
    }
    
}
