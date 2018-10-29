//
//  MarketCharCell.swift
//  FGWallet
//
//  Created by Ivan on 1/18/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class MarketCharCell: UITableViewCell {
    
    @IBOutlet weak var lblPrice0: UILabel!
    
    @IBOutlet weak var lblPrice1: UILabel!
    
    @IBOutlet weak var lblPrice2: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var chart: LineChartView!
    
    @IBOutlet weak var viewPriceCurrent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearText()
//        shadowViewPrice()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func clearText() {
        lblPrice0.text = ""
        lblPrice1.text = ""
        lblPrice2.text = ""
    }
    
    func shadowViewPrice() {
        let shadowPath = UIBezierPath(rect: viewPriceCurrent.bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
    
  

}


