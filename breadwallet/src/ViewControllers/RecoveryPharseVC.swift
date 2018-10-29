//
//  RecoveryPharseVC.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class RecoveryPharseVC: BaseViewController {
    
    @IBOutlet weak var bottomScroolView: NSLayoutConstraint!
    
    var pharsetext = ""
//    let placehoder = "Enter your recovery phrase"
    
    
     let keyboard = KUIKeyboard()
    
    var btnRecovery = UIBarButtonItem()
    
    @IBOutlet weak var txvPhase: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txvPhase.boder()
        txvPhase.placeholder = Klang.enter_recover.localized()
        addToolBarTextView(txvPhase)
       
        addBackButton()
        navigationItem.title = Klang.recovery_phrase.localized()
        btnRecovery = UIBarButtonItem.init(title: Klang.recover.localized(), style: .plain, target: self, action: #selector(tapRecovery))
        navigationItem.rightBarButtonItem = btnRecovery
        keyboard.onChangedKeyboardHeight = { [weak self] (visibleHeight) in
            guard let strongSelf = self else {return}
            strongSelf.bottomScroolView.constant = visibleHeight
            strongSelf.view.layoutIfNeeded()
            
        }
        txvPhase.becomeFirstResponder()
       
        
        
    }
    
    @objc func tapRecovery() {
        guard txvPhase.textColor == .white else {
            return
        }
        guard var text = txvPhase.text, !text.isEmpty else {
            return
        }
        
        
        text = txvPhase.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text == pharsetext {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            UserDefaults.standard.set(true, forKey: FGuserDefault.is_InputRecoveryPhase)
        self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: homeVC), animated: true)
        }else{
            showAlert("recovery not match")
        }
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        revealViewController().panGestureRecognizer().isEnabled = false
        keyboard.addObservers()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        revealViewController().panGestureRecognizer().isEnabled = true
        keyboard.removeObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}


