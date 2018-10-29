//
//  AboutVC.swift
//  FGWallet
//
//  Created by Ivan on 1/11/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class AboutVC: BaseViewController {

    @IBOutlet weak var lblVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        self.navigationItem.title = Klang.about.localized()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
             lblVersion.text = "FG Wallet Ver \(version)"
           
        }
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    

}
