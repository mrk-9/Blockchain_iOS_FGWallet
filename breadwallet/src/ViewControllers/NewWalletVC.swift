//
//  NewWalletVC.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class NewWalletVC: BaseViewController {
    
   
    @IBOutlet weak var viewPhone: UIView!
    
    @IBOutlet weak var viewNewPin: UIView!
    
    @IBOutlet weak var viewRePin: UIView!
    
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var lblNewPin: UILabel!
    
    @IBOutlet weak var lblReEnterPIN: UILabel!
    
    @IBOutlet weak var lblCorterm: UILabel!
    
    @IBOutlet weak var lblIsoCode: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnCreatWallet: UIButton!
    @IBOutlet weak var txfPhone: BaseTextField!
    @IBOutlet weak var txfNewPin: BaseTextField!
    @IBOutlet weak var txfRePin: BaseTextField!
    @IBOutlet weak var bottomScrollView: NSLayoutConstraint!
    
    
 
    
    
    var country = Country.init(name: "Japan", isoCode: "JP", callingCode: "+81")
    let keyboard = KUIKeyboard()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        revealViewController().panGestureRecognizer().isEnabled = false
        keyboard.addObservers()
        setupNavi()
        addBackButton()
    }
    
    func setText() {
        lblMobileNumber.text = Klang.mobile_number.localized()
        lblNewPin.text = Klang.new_pin.localized()
        lblReEnterPIN.text = Klang.re_enter_pin.localized()
        lblCorterm.text = Klang.terms_conditions.localized()
        btnCreatWallet.setTitle(Klang.create_wallet.localized(), for: .normal)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        revealViewController().panGestureRecognizer().isEnabled = true
        keyboard.removeObservers()
    }
    
    private func setup() {
       
        btnCreatWallet.boder()
        addTapDismiss()
        addToolBar(txfPhone)
        addToolBar(txfRePin)
        addToolBar(txfNewPin)
        keyboard.onChangedKeyboardHeight = { [weak self] (visibleHeight) in
            guard let strongSelf = self else {return}
            strongSelf.bottomScrollView.constant = visibleHeight
            strongSelf.view.layoutIfNeeded()
        }
        lblIsoCode.text = country.isoCode
        lblCode.text = country.callingCode
        setText()
        
        
    }
    

    
    func checkOK() -> Bool {
        
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapBtn_CreatWallet(_ sender: Any) {
        guard let strPhone = txfPhone.text, !strPhone.isEmpty else {
//            showAlert(MSG.phoneNumberdRequired)
            viewPhone.shake()
            txfPhone.becomeFirstResponder()
            return
        }
        guard let strNewPin = txfNewPin.text, !strNewPin.isEmpty else {
            viewNewPin.shake()
            txfNewPin.becomeFirstResponder()
            return
        }
        guard let strRePin  = txfRePin.text, !strRePin.isEmpty else {
           viewRePin.shake()
            txfRePin.becomeFirstResponder()
            return
        }
        
        guard strNewPin == strRePin else {
            viewRePin.shake()
            showAlert(MSG.rePinnotMatch)
            txfRePin.becomeFirstResponder()
            return
        }
        
        showLoading()
        
        
        
        globalAPI?.verification(lblCode.text! + strPhone)
        {
            (success, error)
            
            in
            hideLoading()
            if error == nil
            {
                
                if(globalAPI?.walletManager.noWallet==true)
                {
                    // let tmp = 0;
                    //  complete:@escaping
                    
                    
                    if(globalAPI?.createNewWallet()==false)
                    {
                        self.showAlert("Could not create wallet")
                        return
                    }
                }
                
                let submitOTP = self.storyboard?.instantiateViewController(withIdentifier: "SubmitOTPVC") as! SubmitOTPVC
                submitOTP.strPhone = self.lblCode.text! + strPhone
                submitOTP.strPin = strNewPin
                UserDefaults.standard.set(strNewPin, forKey: FGuserDefault.pin)
                self.navigationController?.pushViewController(submitOTP, animated: true)
                
            }else {
                self.showAlert(error?.msg ?? MSG.occurred)
                
            }
            
        }
    }
    
    @IBAction func didTapSelectCodeCountry(_ sender: Any) {
        view.endEditing(true)
        let countryPickerView = CountryPickerViewController()
        countryPickerView.delegate = self
        let navigationController = UINavigationController(rootViewController: countryPickerView)
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension NewWalletVC: CountryPickerViewControllerDelegate {
    func countryPickerViewControllerDidCancel(_ countryPickerViewController: CountryPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: Country) {
        self.country = country
        lblIsoCode.text = country.isoCode
        lblCode.text = country.callingCode
        dismiss(animated: true, completion: nil)

    }
}

extension NewWalletVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfPhone {
            txfNewPin.becomeFirstResponder()
            return true
        }
        
        if textField == txfNewPin {
            txfRePin.becomeFirstResponder()
            return true
        }
        
        if textField == txfRePin {
            view.endEditing(true)
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
       
        if textField == txfRePin || textField == txfNewPin {
            let newLength = text.count + string.count - range.length
           
                return newLength <= 4
           
        
        }
        return true
        
    }
    
}
