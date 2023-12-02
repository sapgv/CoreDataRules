//
//  CDUser + Extensions.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import Foundation

extension CDUser {
    
    func fill(data: [String: Any]) {
        let id = data["id"] as? Int ?? 0
        self.id = id.int16
        self.name = data["name"] as? String ?? ""
    }
    
}
