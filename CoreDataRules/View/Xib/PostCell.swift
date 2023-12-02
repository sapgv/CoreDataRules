//
//  PostCell.swift
//  CoreDataRules
//
//  Created by Grigory Sapogov on 02.12.2023.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(cdPost: CDPost) {
        self.titleLabel.text = cdPost.title
        self.bodyLabel.text = cdPost.body
    }
    
}
