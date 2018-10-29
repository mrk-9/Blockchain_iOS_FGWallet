//
//  ChangeLanguage.swift
//  FGWallet
//
//  Created by Ivan on 1/13/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class ChangeLanguage: BaseViewController {
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var lblJapan: UILabel!
    
    @IBOutlet weak var criceBigEnglish: UIView!
    
    @IBOutlet weak var cricleSmalEnglish: UIView!
    
    @IBOutlet weak var criceBigJapan: UIView!
    
    var isLanguageEn: Bool? = nil
    
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var cricleSmallJapn: UIView!
    @IBOutlet weak var lblEnglish: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        addBackButton()
        btnOk.boder()
        criceBigEnglish.boder(.white, 1, 10)
        cricleSmalEnglish.boder(.white, 1, 5)
        criceBigJapan.boder(.white, 1, 10)
        cricleSmallJapn.boder(.white, 1, 5)
        cricleSmalEnglish.backgroundColor = FGColor.primary
        cricleSmallJapn.backgroundColor = FGColor.primary
        if Localize.currentLanguage() == "en" {
            cricleSmalEnglish.backgroundColor = .white
            criceBigJapan.backgroundColor = FGColor.primary
            isLanguageEn = true
        }
        
        if Localize.currentLanguage() == "ja" {
            cricleSmalEnglish.backgroundColor = FGColor.primary
            cricleSmallJapn.backgroundColor = .white
            isLanguageEn = false
        }
        setText()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func setText() {
        self.navigationItem.title = Klang.change_language.localized()
        lblInfo.text = Klang.change_language.localized()
        lblJapan.text = Localize.displayNameForLanguage("ja").localized()
        lblEnglish.text = Localize.displayNameForLanguage("en").localized()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @IBAction func didTapSelectEnglish(_ sender: Any) {
        cricleSmalEnglish.backgroundColor = .white
        cricleSmallJapn.backgroundColor = FGColor.primary
        isLanguageEn = true
    }
    
    @IBAction func didTapSelectJapan(_ sender: Any) {
        cricleSmalEnglish.backgroundColor = FGColor.primary
        cricleSmallJapn.backgroundColor = .white
        isLanguageEn = false
    }
    
    @IBAction func didTapOk(_ sender: Any) {
        
        guard  let isLanguageEn = isLanguageEn else {
            return
        }
        if isLanguageEn == true {
            Localize.setCurrentLanguage("en")
            
        }else{
            Localize.setCurrentLanguage("ja")
            
        }
        
        
    }
    
}
