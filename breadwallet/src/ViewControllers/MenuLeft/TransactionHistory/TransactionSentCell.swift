//
//  TransactionSentCell.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class TransactionSentCell: UITableViewCell {
    
    
    @IBOutlet weak var lblSend: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblMemo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
