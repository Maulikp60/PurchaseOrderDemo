//
//  InvoicesTableViewCell.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//

import UIKit

class InvoicesTableViewCell: UITableViewCell {

    @IBOutlet var invoiceNumberLabel: UILabel!
    @IBOutlet var receivedStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
