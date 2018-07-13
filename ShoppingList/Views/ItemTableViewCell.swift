//
//  ItemTableViewCell.swift
//  ShoppingList
//
//  Created by Zachary Frew on 7/13/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol
protocol ItemTableViewCellDelegate: class {
    func cellButtonTapped(_ cell: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hasBeenPurchasedButton: UIButton!
    
    // MARK: - Actinos
    @IBAction func hasBeenPurchasedButtonTapped(_ sender: Any) {
        delegate?.cellButtonTapped(self)
    }
    
    // MARK: - Properties
    weak var delegate: ItemTableViewCellDelegate?
    
    // MARK: - Methods
    func updateCell(item: Item) {
        let imageName = item.hasBeenPurchased ? "complete" : "incomplete"
        guard let image = UIImage(named: imageName) else { return }
        hasBeenPurchasedButton.setBackgroundImage(image, for: .normal)
        nameLabel.text = item.name
    }
    
}
