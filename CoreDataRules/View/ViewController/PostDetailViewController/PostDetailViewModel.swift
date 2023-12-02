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
    
    var cdPost: CDPost { get }

    var sections: [EditSection] { get }
    
    func save()
    
    func updateUser(cdUser: CDUser)
    
}

final class PostDetailViewModel: IPostDetailViewModel {
    
    var updateUserCompletion: (() -> Void)?
    
    var saveCompletion: ((Error?) -> Void)?
    
    let cdPost: CDPost
    
    private let viewContext: NSManagedObjectContext
    
    private(set) var sections: [EditSection] = []
    
    init(cdPost: CDPost, viewContext: NSManagedObjectContext) {
        
        self.cdPost = cdPost
        self.viewContext = viewContext
        
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
        
        Model.coreData.save(in: self.viewContext) { status in
            
            switch status {
            case .hasNoChanges, .saved:
                self.saveCompletion?(nil)
            default:
                self.saveCompletion?(StorageError.saveFailure(CDUser.entityName).NSError)
            }
            
        }
        
    }
    
    func updateUser(cdUser: CDUser) {
        
        guard let cdUserInContext = self.viewContext.object(with: cdUser.objectID) as? CDUser else { return }
        
        self.cdPost.cdUser = cdUserInContext
        
        self.updateUserCompletion?()
        
    }
    
}
