//
//  PostListViewController.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 01.12.2023.
//

import UIKit
import CoreData

class PostListViewController: ListViewController {

    var viewModel: IPostListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        self.view.backgroundColor = .white
        self.setupViewModel()
        self.setupFetchController()
        self.setupTableView()
        self.setupNavigationItems()
        self.layout()
        self.updateControllerResults()
    }
    
    private func setupViewModel() {
        
        self.viewModel.createPostCompletion = { [weak self] cdPost, viewContext in
            
            self?.showPost(cdPost: cdPost, viewContext: viewContext)
            
        }
        
    }
    
    private func setupFetchController() {
        
        self.controller = Model.coreData.fetchedResultController(entity: CDPost.entityName, sectionKey: nil, cacheName: nil, sortKey: "date", sortKeys: nil, sortDescriptors: nil, fetchPredicates: nil, ascending: true, batchSize: 50, fetchContext: nil)
        self.controller?.delegate = self
        
    }
    
    override func setupTableView() {
        super.setupTableView()
        self.tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    
    private func setupNavigationItems() {
        
        let createPostButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createPost))
        self.navigationItem.rightBarButtonItem = createPostButton
        
    }
    
    @objc
    private func createPost() {
        
        self.viewModel.createPost()
        
    }
    
    private func showPost(cdPost: CDPost, viewContext: NSManagedObjectContext) {
        
        let postDetailViewModel = PostDetailViewModel(cdPost: cdPost, viewContext: viewContext)
        
        let postDetailViewController = PostDetailViewController()
        
        postDetailViewController.viewModel = postDetailViewModel
        
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
        
    }
    
}

extension PostListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        guard let cdPost = self.controller?.fetchedObjects?[indexPath.row] as? CDPost else {
            return UITableViewCell()
        }
        
        cell.setup(cdPost: cdPost)
        
        return cell
    }
    
}
