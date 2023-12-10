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
        self.setupNavigationItems()
        self.updateControllerResults()
    }
    
    private func setupViewModel() {
        
        self.viewModel.createPostCompletion = { [weak self] cdPost, viewContext in
            
            self?.showPost(cdPost: cdPost, viewContext: viewContext)
            
        }
        
        self.viewModel.editPostCompletion = { [weak self] cdPost, viewContext in
            
            self?.showPost(cdPost: cdPost, viewContext: viewContext)
            
        }
        
        self.viewModel.deletePostCompletion = { error in
            
            if let error = error {
                print(error)
                return
            }
            
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
        
        postDetailViewController.completion = { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
            
        }
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            
            guard let cdPost = self?.controller?.fetchedObjects?[indexPath.row] as? CDPost else {
                completion(true)
                return
            }
            
            self?.viewModel.delete(cdPost: cdPost)
            
            completion(true)
            
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Редактировать") { [weak self] _, _, completion in
            
            guard let cdPost = self?.controller?.fetchedObjects?[indexPath.row] as? CDPost else {
                completion(true)
                return
            }
            
            self?.viewModel.edit(cdPost: cdPost)
            
            completion(true)
            
        }
        
        editAction.backgroundColor = .systemYellow
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return config
        
    }
    
}
