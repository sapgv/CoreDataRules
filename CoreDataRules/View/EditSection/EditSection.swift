//
//  EditSection.swift
//  Agronom
//
//  Created by Grigory Sapogov on 18.11.2023.
//

import CoreData

class EditSection {

    public let title: String
    
    public let rows: [EditRow]
    
    public required init(title: String = "", rows: [EditRow] = []) {
        self.title = title
        self.rows = rows
    }
    
}
