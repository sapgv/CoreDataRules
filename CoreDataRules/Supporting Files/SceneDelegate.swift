//
//  SceneDelegate.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 01.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: scene)
        self.window?.makeKeyAndVisible()
        
        let viewController = self.createTabBarViewController()
        
        self.window?.rootViewController = viewController
        
    }
    
    private func createTabBarViewController() -> UIViewController {

        let postListViewCOntroller = self.createPostListViewController()
        
        let userListViewController = self.createUserListViewController()
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([postListViewCOntroller, userListViewController], animated: false)
        
        return tabBarController
        
    }
    
    private func createPostListViewController() -> UIViewController {
        
        let viewController = PostListViewController()
        viewController.viewModel = PostListViewModel()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "doc"), tag: 0)
        
        return navigationController
        
    }
    
    private func createUserListViewController() -> UIViewController {
        
        let viewController = UserListViewController()
        viewController.viewModel = UserListViewModel()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person"), tag: 1)
        
        return navigationController
        
    }

}

