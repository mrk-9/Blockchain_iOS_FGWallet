//
//  DisplayPharseVC.swift
//  FGWallet
//
//  Created by Ivan on 1/14/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class DisplayPharseVC: BaseViewController {
  
    @IBOutlet weak var lblPharse: UILabel!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        lblTitle.text = Klang.title_recovery_phrase2.localized()
        //lblPharse.text = FGuserDefault.getRecoveryPhase()
        lblPharse.text = globalAPI?.getPhrase()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
