//
//  editTableCell.swift
//  KioskScanner
//
//  Created by Kenny Pham on 3/16/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import UIKit

class editTableCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
