//
//  ExtensionDouble.swift
//  FGWallet
//
//  Created by Ivan on 1/8/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

extension Double {
    func formatBTC() -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.maximumFractionDigits = 8
        return numberFormat.string(from: NSNumber.init(value: self)) ?? ""
    }
    
    func formatJPY() -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.maximumFractionDigits = 0
        return numberFormat.string(from: NSNumber.init(value: self)) ?? ""
    }
    
}

