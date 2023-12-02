//
//  UserListViewController.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import UIKit
import CoreData

class UserListViewController: UIViewController {

    var viewModel: IUserListViewModel!
    
    private var tableView = UITableView(frame: .zero)
    
    private var fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        self.view.backgroundColor = .white
        self.setupViewModel()
        self.setupFetchController()
        self.setupTableView()
        self.setupRefreshControl()
        self.layout()
        self.fetch()
    }
    
    private func setupViewModel() {
        
        self.viewModel.updateCompletion = { [weak self] error in
            
            self?.refreshControl.endRefreshing()
            
            if let error = error {
                print(error)
                return
            }
            
            self?.fetch()
            
        }
        
    }
    
    private func setupFetchController() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CDUser.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        self.fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Model.coreData.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
    private func setupRefreshControl() {
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    private func setupTableView() {
        
        self.tableView.refreshControl = refreshControl
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
    }
    
    private func layout() {
        
        self.view.addSubview(tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    private func fetch() {
        
        try? self.fetchController?.performFetch()
        
        self.tableView.reloadData()
        
    }
    
    @objc
    private func refresh() {
        
        self.viewModel.update()
        
    }

}

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchController = self.fetchController else { return 0 }
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        guard let cdUser = self.fetchController?.fetchedObjects?[indexPath.row] as? CDUser else {
            return UITableViewCell()
        }
        
        cell.setup(cdUser: cdUser)
        
        return cell
        
    }
    
}
