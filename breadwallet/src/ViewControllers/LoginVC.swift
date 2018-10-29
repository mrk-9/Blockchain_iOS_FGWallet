//
//  LoginVC.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    
    @IBOutlet weak var lblEnterYourPin: UILabel!
    @IBOutlet weak var viewPin: UIView!
    @IBOutlet weak var bottomScrollView: NSLayoutConstraint!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txfPIN: BaseTextField!
    let keyboard = KUIKeyboard()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pin = (UserDefaults.standard.value(forKey: FGuserDefault.pin) as? String), !pin.isEmpty else {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: mainVC), animated: true)
            return
        }
        
        addToolBar(txfPIN)
        btnLogin.boder()
        lblEnterYourPin.text = Klang.enter_pin.localized()
        
        keyboard.onChangedKeyboardHeight = { [weak self] (visibleHeight) in
            guard let strongSelf = self else {return}
            strongSelf.bottomScrollView.constant = visibleHeight
            strongSelf.view.layoutIfNeeded()
            
        }
        navigationItem.leftBarButtonItem = nil
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        revealViewController().panGestureRecognizer().isEnabled = false
        setupNavi()
        navigationItem.leftBarButtonItem = nil
        
        keyboard.addObservers()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        revealViewController().panGestureRecognizer().isEnabled = true
        keyboard.removeObservers()
    }
    
    @IBAction func didTapBtnLogin(_ sender: Any)
    {
        guard let pin = (UserDefaults.standard.value(forKey: FGuserDefault.pin) as? String), !pin.isEmpty else {
            view.endEditing(true)
            self.view.makeToast(MSG.occurred)
            return
        }
        guard let textPin = txfPIN.text, !textPin.isEmpty else {
            viewPin.shake()
            return
        }
        if pin == textPin
        {
            if FGuserDefault.check_InputRecoveryPhase() == true
            {
                let homVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: homVC), animated: true)
            }
            else
            {
              
                /*
               let  recovery = self.storyboard?.instantiateViewController(withIdentifier: "RecoveryPharseVC") as! RecoveryPharseVC
                self.navigationController?.pushViewController(recovery, animated: true)
 */
                let showRecoveryVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowRecoveryPhaseVC") as! ShowRecoveryPhaseVC
                
                self.navigationController?.pushViewController(showRecoveryVC, animated: true)
                
                
            }
            
        }else{
            viewPin.shake()
            view.endEditing(true)
           
        }
        
    }
    
    
}

extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4
    }
    
}
