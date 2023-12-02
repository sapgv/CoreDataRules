//
//  ListViewController.swift
//  Agronom
//
//  Created by Grigory Sapogov on 17.11.2023.
//

import UIKit
import CoreData

class ListViewController: UIViewController, GrowingTableViewCellProtocol {
    
    var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var bottomConstraint: NSLayoutConstraint?
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    private var isKeyboardNotification = false
    
    public lazy var controller: NSFetchedResultsController<NSManagedObject>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupTableView()
        self.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func layout() {
        
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.bottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        self.bottomConstraint?.isActive = true
        
    }
    
    func updateControllerResults() {
        guard let controller = controller else { return }
        do {
            try controller.performFetch()
        } catch {
            let fetchError = error as NSError
            Log.debug("CoreData", "Unable to Perform Fetch Request" + "\n" + fetchError.localizedDescription)
        }
    }
    
    func addKeyboard() {
        guard !self.isKeyboardNotification else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer!.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func removeKeyboard() {
        NotificationCenter.default.removeObserver(self)
        tapGestureRecognizer = nil
        isKeyboardNotification = false
    }
    
    @objc
    func keyboardWillAppear(notification: Notification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let value = keyboardSize.height - self.view.safeAreaInsets.bottom

        bottomConstraint?.constant = -value
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        bottomConstraint?.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func object(forIndexPath indexPath: IndexPath) -> Any? {
        self.controller?.object(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = controller?.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView?.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView?.insertRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            tableView?.reloadData()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: break
        }
    }
}


