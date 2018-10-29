//
//  ImportantVC.swift
//  FGWallet
//
//  Created by Ivan on 1/14/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class ImportantVC: BaseViewController {

    @IBOutlet weak var btnPharse: UIButton!
    
    @IBOutlet weak var lblImportant: UILabel!
    
    @IBOutlet weak var lblDoNottype: UILabel!
    
    @IBOutlet weak var lblNever: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPharse.boder()
        addBackButton()
        
        lblImportant.text = Klang.important.localized()
        lblDoNottype.text = Klang.title_recovery_phrase.localized()
        lblNever.text = Klang.msg_recovery_phrase.localized()
        btnPharse.setTitle(Klang.show_phrase.localized(), for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func didTapShowPharse(_ sender: Any) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "DisplayPharseVC") as! DisplayPharseVC, animated: true)
    }
    

}
