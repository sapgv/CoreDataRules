//
//  PostListViewController.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 01.12.2023.
//

import UIKit
import CoreData

class PostListViewController: UIViewController {

    var viewModel: IPostListViewModel!
    
    private var tableView = UITableView(frame: .zero)
    
    private var fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        self.view.backgroundColor = .white
        self.setupFetchController()
        self.setupTableView()
        self.layout()
        self.fetch()
    }
    
    private func setupViewModel() {
        
    }
    
    private func setupFetchController() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CDPost.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        self.fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Model.coreData.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
    private func setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
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
    
}

extension PostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchController = self.fetchController else { return 0 }
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
}
