//
//  UserListViewController.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import UIKit
import CoreData

class UserListViewController: ListViewController {

    var selectCompletion: ((CDUser) -> Void)?
    
    var viewModel: IUserListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        self.view.backgroundColor = .white
        self.setupViewModel()
        self.setupFetchController()
        self.setupRefreshControl()
        self.setupTableView()
        self.layout()
        self.updateControllerResults()
    }
    
    private func setupViewModel() {
        
        self.viewModel.updateCompletion = { [weak self] error in
            
            self?.refreshControl?.endRefreshing()
            
            if let error = error {
                print(error)
                return
            }
            
            self?.updateControllerResults()
            
        }
        
    }
    
    private func setupFetchController() {
        
        self.controller = Model.coreData.fetchedResultController(entity: CDUser.entityName, sectionKey: nil, cacheName: nil, sortKey: "id", sortKeys: nil, sortDescriptors: nil, fetchPredicates: nil, ascending: true, batchSize: 50, fetchContext: nil)
        self.controller?.delegate = self
        
    }
    
    private func setupRefreshControl() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    override func setupTableView() {
        super.setupTableView()
        self.tableView.refreshControl = self.refreshControl
        self.tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    @objc
    private func refresh() {
        
        self.viewModel.update()
        
    }

}

extension UserListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchController = self.controller else { return 0 }
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        guard let cdUser = self.controller?.fetchedObjects?[indexPath.row] as? CDUser else {
            return UITableViewCell()
        }
        
        cell.setup(cdUser: cdUser)
        
        return cell
        
    }
    
}

extension UserListViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cdUser = self.controller?.fetchedObjects?[indexPath.row] as? CDUser else { return }
        
        self.selectCompletion?(cdUser)
        
    }
    
}
