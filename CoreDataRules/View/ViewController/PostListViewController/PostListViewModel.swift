//
//  PostListViewModel.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import Foundation

protocol IPostListViewModel: AnyObject {
    
    
}

final class PostListViewModel: IPostListViewModel {
    
    private let postStorage: IPostStorage
    
    init(postStorage: IPostStorage = PostStorage()) {
        self.postStorage = postStorage
    }
    
}
