//
//  PostDetailViewController.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import UIKit

final class PostDetailViewController: ListViewController {
    
    var completion: (() -> Void)?
    
    var viewModel: PostDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post"
        self.setupViewModel()
        self.setupTableView()
        self.setupNavigationButton()
        self.layout()
    }
    
    override func setupTableView() {
        super.setupTableView()
        self.tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        self.tableView.register(UINib(nibName: "EditTextCell", bundle: nil), forCellReuseIdentifier: "EditTextCell")
    }
    
    private func setupViewModel() {
        
        self.viewModel.updateUserCompletion = { [weak self] in
            
            self?.tableView.reloadData()
            
        }
        
    }
    
    private func setupNavigationButton() {
        
        let button = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = button
        
    }
    
    @objc
    private func save() {
        
        self.viewModel?.save()
        
    }
    
    private func showSelectUser() {
        
        let viewController = UserListViewController()
        viewController.selectCompletion = { [weak self] cdUser in
            self?.viewModel.updateUser(cdUser: cdUser)
        }
        viewController.viewModel = UserListViewModel()

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension PostDetailViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.sections.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let viewModel = self.viewModel else { return nil }
        
        let section = viewModel.sections[section]
        
        return section.title
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let viewModel = self.viewModel else { return UITableViewCell() }
        
        let row = viewModel.sections[indexPath.section].rows[indexPath.row]
        
        switch row {
            
        case is PostUserRow:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
                return UITableViewCell()
            }
            
            cell.nameLabel.text = self.viewModel.cdPost.cdUser?.name ?? "Выберите пользователя"
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
            
        case is PostTitleRow:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditTextCell", for: indexPath) as? EditTextCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "Заголовок"
            cell.growingDelegate = self
            cell.editChaged = { text in
                self.viewModel?.cdPost.title = text
            }
            
            return cell
            
        case is PostBodyRow:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditTextCell", for: indexPath) as? EditTextCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "Описание"
            cell.growingDelegate = self
            cell.editChaged = { text in
                self.viewModel?.cdPost.body = text
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
}

extension PostDetailViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = viewModel.sections[indexPath.section].rows[indexPath.row]
        
        switch row {
        case is PostUserRow:
            
            self.showSelectUser()
            
        default:
            break
        }
        
    }
    
}
