//
//  PurchaseOrderTableViewCell.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//

import UIKit

class PurchaseOrderTableViewCell: UITableViewCell {

    @IBOutlet var purchaseOrderIDLabel: UILabel!
    @IBOutlet var numberOfItemsLabel: UILabel!
    @IBOutlet var lastUpdatedDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
