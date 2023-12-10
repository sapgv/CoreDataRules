//
//  PostDetailViewModel.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import CoreData

protocol IPostDetailViewModel: AnyObject {
    
    var updateUserCompletion: (() -> Void)? { get set }
    
    var saveCompletion: ((Error?) -> Void)? { get set }
    
    var updateCompletion: ((Error?) -> Void)? { get set }
    
    var cdPost: CDPost { get }

    var sections: [EditSection] { get }
    
    func save()
    
    func update()
    
    func updateUser(cdUser: CDUser)
    
}

final class PostDetailViewModel: IPostDetailViewModel {
    
    var updateUserCompletion: (() -> Void)?
    
    var saveCompletion: ((Error?) -> Void)?
    
    var updateCompletion: ((Error?) -> Void)?
    
    let cdPost: CDPost
    
    private let viewContext: NSManagedObjectContext
    
    private(set) var sections: [EditSection] = []
    
    private let postStorage: IPostStorage
    
    init(cdPost: CDPost,
         viewContext: NSManagedObjectContext,
         postStorage: IPostStorage = PostStorage()) {
        self.cdPost = cdPost
        self.viewContext = viewContext
        self.postStorage = postStorage
        
        self.sections = [
            
            EditSection(title: "User", rows: [
                
                PostUserRow()
            
            ]),
            
            EditSection(title: "Post", rows: [
                
                PostTitleRow(),
                
                PostBodyRow(),
                
            ]),
            
        ]
        
    }
    
    func save() {
        
        self.viewContext.refresh(self.cdPost, mergeChanges: true)
        
//        self.viewContext.refreshAllObjects()
        
//        self.viewContext.mergePolicy = NSMergePolicy.overwrite
        
        Model.coreData.save(in: self.viewContext) { [weak self] status in
            
            switch status {
            case .hasNoChanges, .saved:
                self?.saveCompletion?(nil)
            case let .error(error):
                self?.saveCompletion?(error.NSError)
            }
            
        }
        
    }
    
    func update() {
        
//        self.postStorage.markBatch(cdPost: cdPost) { [weak self] error in
//
//            self?.updateCompletion?(error)
//
//        }
        
        self.postStorage.mark(cdPost: cdPost) { [weak self] error in
            
            self?.updateCompletion?(error)
            
        }
        
    }
//
    func updateUser(cdUser: CDUser) {
        
        guard let cdUserInContext = self.viewContext.object(with: cdUser.objectID) as? CDUser else { return }
        
        self.cdPost.cdUser = cdUserInContext
        
        self.updateUserCompletion?()
        
    }
    
}
