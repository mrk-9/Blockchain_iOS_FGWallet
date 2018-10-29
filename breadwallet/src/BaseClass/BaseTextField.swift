//
//  BaseTextField.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
       
    }
    
 
    
    private func setup() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        leftView = paddingView
        leftViewMode = .always
        clearButtonMode = .whileEditing
        
    }
}
