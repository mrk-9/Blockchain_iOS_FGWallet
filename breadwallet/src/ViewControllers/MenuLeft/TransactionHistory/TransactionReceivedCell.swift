//
//  TransactionReceivedCell.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class TransactionReceivedCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblReviced: UILabel!
    
    
    @IBOutlet weak var lblAmmout: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
