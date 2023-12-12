//
//  MarkCell.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 12.12.2023.
//

import UIKit

class MarkCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = "Отметка"
    }
    
    func setup(mark: Bool) {
        self.valueLabel.text = mark ? "Да" : "Нет"
    }
    
}
