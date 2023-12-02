//
//  CDUser + Extensions.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import Foundation

extension CDUser {
    
    func fill(data: [String: Any]) {
        self.id = data["id"] as? Int16 ?? 0
        self.name = data["name"] as? String ?? ""
    }
    
}
