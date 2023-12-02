//
//  PostDetailViewModel.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import CoreData

protocol IPostDetailViewModel: AnyObject {
    
    var saveCompletion: ((Error?) -> Void)? { get set }
    
    var cdPost: CDPost { get }

    var sections: [EditSection] { get }
    
    func save()
    
}

final class PostDetailViewModel: IPostDetailViewModel {
    
    var saveCompletion: ((Error?) -> Void)?
    
    let cdPost: CDPost
    
    let viewContext: NSManagedObjectContext
    
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
    
}
