//
//  GrowingTableViewCellProtocol.swift
//  Agronom
//
//  Created by Grigory Sapogov on 18.11.2023.
//

import UIKit

protocol GrowingTableViewCellProtocol: AnyObject {
    
    var tableView: UITableView! { get }
    
    func updateHeightOfRow(_ cell: UITableViewCell, _ textView: UITextView)
}

extension GrowingTableViewCellProtocol {
    
    func updateHeightOfRow(_ cell: UITableViewCell, _ textView: UITextView) {
        
        let size = textView.bounds.size
        
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
        
    }
    
}

