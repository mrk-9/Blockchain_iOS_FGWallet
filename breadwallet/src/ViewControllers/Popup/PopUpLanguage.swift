//
//  PopUpLanguage.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class PopUpLanguage: UIView {
    
    var tapEN: (() -> ())?
    var tapJP: (() -> ())?

    @IBOutlet weak var lblEnglish: UILabel!
    
    @IBOutlet weak var lblJapan: UILabel!
    @IBAction func didTapEnglish(_ sender: Any) {
        tapEN?()
    }
    
    @IBAction func didTapJaPan(_ sender: Any) {
        tapJP?()
    }
    
}
