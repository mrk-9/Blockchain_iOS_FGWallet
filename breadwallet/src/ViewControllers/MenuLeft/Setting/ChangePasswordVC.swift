//
//  ChangePasswordVC.swift
//  FGWallet
//
//  Created by Ivan on 1/14/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var lblOldPin: UILabel!
    
    @IBOutlet weak var lblNewPin: UILabel!
    @IBOutlet weak var lblRePIN: UILabel!
    
    @IBOutlet weak var txfOlsPIN: BaseTextField!
    
    @IBOutlet weak var txfNewPIN: BaseTextField!
    
    @IBOutlet weak var viewOldPIN: UIView!
    
    @IBOutlet weak var txfRePIN: BaseTextField!
    
    @IBOutlet weak var viewRePIN: UIView!
    @IBOutlet weak var viewNewPIN: UIView!
    @IBOutlet weak var btnChangPassword: UIButton!
    
    @IBOutlet weak var bottomScorrleview: NSLayoutConstraint!
    
    let keyboard = KUIKeyboard()
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        navigationItem.title = Klang.change_password.localized()
        lblOldPin.text = Klang.old_pin.localized()
        lblNewPin.text = Klang.new_pin.localized()
        lblRePIN.text = Klang.re_enter_pin.localized()
        btnChangPassword.boder()
        addTapDismiss()
        addToolBar(txfOlsPIN)
        addToolBar(txfNewPIN)
        addToolBar(txfRePIN)
        btnChangPassword.setTitle(Klang.change_password.localized(), for: .normal)
        keyboard.onChangedKeyboardHeight = { invisible in
            self.bottomScorrleview.constant = invisible
            self.view.layoutIfNeeded()
           
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboard.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.removeObservers()
    }
    

    @IBAction func didTapChangePassword(_ sender: Any) {
        guard let old = txfOlsPIN.text, !old.isEmpty else{
            btnChangPassword.shake()
            return
        }
        
        guard let newPin = txfNewPIN.text, !newPin.isEmpty else{
            btnChangPassword.shake()
            return
        }
        
        guard let reEnterPin = txfRePIN.text, !reEnterPin.isEmpty else{
            btnChangPassword.shake()
            return
        }
        
        guard  newPin == reEnterPin  else {
            
            btnChangPassword.shake()
            return
        }
        showLoading()
        API.changePassword(old, newPIN: newPin) { (error) in
            hideLoading()
            guard error == nil else{
                self.showAlert(error!.msg ?? MSG.occurred)
                return
            }
            
            UserDefaults.standard.set(newPin, forKey: FGuserDefault.pin)
            
            
            let alert = UIAlertController(title: APPName, message: "Success! Your Password has been changed!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                 self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
           
            
        }
        
        
    }
    
}

extension ChangePasswordVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfOlsPIN {
            txfNewPIN.becomeFirstResponder()
            return true
        }
        
        if textField == txfNewPIN {
            txfRePIN.becomeFirstResponder()
            return true
        }
        
        if textField == txfRePIN {
            view.endEditing(true)
            return true
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4
    }
}
