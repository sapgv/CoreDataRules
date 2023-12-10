//
//  Extensions.swift
//  Agronom
//
//  Created by Grigory Sapogov on 17.11.2023.
//

import UIKit
import CoreData

extension Error {
    
    var NSError: Foundation.NSError {
        return Foundation.NSError(domain: "App.NSError", code: 0, userInfo: [NSLocalizedDescriptionKey: self.localizedDescription])
    }
    
}

extension UINavigationBar {
    
    static func restoreAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
}

extension UITabBar {
    
    static func restoreAppearance() {
        let appearance = UITabBarAppearance()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
}

extension UITableView {
    
    static func restoreAppearance() {
        UITableView.appearance().sectionHeaderTopPadding = 0.0
    }
    
}

extension NSManagedObjectContext {
    
//    func objectInContext<T: NSManagedObject>(_ type: T.Type, objectID: NSManagedObjectID?) -> T? {
//        guard let objectID = objectID else { return nil }
//        return self.object(with: objectID) as? T
//    }
    
}

public extension NSManagedObject {
    
    static var entityName: String {
        return String(describing: self)
    }
    
}

extension Int {
    
    var int16: Int16 {
        Int16(self)
    }
    
}
