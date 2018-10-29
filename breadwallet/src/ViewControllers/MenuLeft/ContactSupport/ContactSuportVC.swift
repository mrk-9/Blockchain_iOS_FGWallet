//
//  ContactSuportVC.swift
//  FGWallet
//
//  Created by Ivan on 1/13/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class ContactSuportVC: BaseViewController {
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblPassword: UILabel!
    
    @IBOutlet weak var lblInquiry: UILabel!
    
    @IBOutlet weak var txfName: BaseTextField!
    
    @IBOutlet weak var txfEmail: BaseTextField!
    
    @IBOutlet weak var txfPassword: BaseTextField!
    
    @IBOutlet weak var txvInquiry: UITextView!
    
    @IBOutlet weak var bottomScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var viewName: UIView!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    let keyboard = KUIKeyboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        btnSubmit.boder()
        navigationItem.title = Klang.contact_support.localized()
        lblName.text = Klang.name.localized()
        btnSubmit.setTitle(Klang.submit.localized(), for: .normal)
        lblInquiry.text = Klang.inquiry.localized()
        lblEmail.text = Klang.email.localized()
        keyboard.onChangedKeyboardHeight = { visible in
            self.bottomScrollView.constant = visible >= 66 ? visible : 60
            self.view.layoutIfNeeded()
        }
        addTapDismiss()
        addToolBar(txfName)
        addToolBar(txfEmail)
        addToolBar(txfPassword)
        addToolBarTextView(txvInquiry)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboard.addObservers()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.removeObservers()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        
        guard let name = txfName.text, !name.isEmpty else {
            viewName.shake()
            return
        }
        guard let email = txfEmail.text, !email.isEmpty else {
            viewEmail.shake()
            return
        }
        
        guard email.isValidEmail() == true else {
            viewEmail.shake()
            return
        }
        
        //        guard let password = txfPassword.text, !password.isEmpty else {
        //            viewPassword.shake()
        //            return
        //        }
        var text = "Email: \(email)\n"
        if let request = txvInquiry.text {
            text = text + request
        }
        let skpMessage = SKPSMTPMessage()
        skpMessage.fromEmail = EmailSuport.send
        skpMessage.toEmail = EmailSuport.revice
        skpMessage.relayHost = EmailSuport.hostName
        //        skpMessage.relayPorts = [465]
        skpMessage.login = EmailSuport.send
        skpMessage.requiresAuth = true
        skpMessage.pass = EmailSuport.password
        skpMessage.wantsSecure = true
        let dict: [String: Any] = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8",
                                   kSKPSMTPPartContentTransferEncodingKey: "8bit",
                                   kSKPSMTPPartMessageKey: text]
        skpMessage.subject = EmailSuport.subject
        skpMessage.parts = [dict]
        skpMessage.validateSSLChain = true
        skpMessage.delegate = self
        showLoading()
        DispatchQueue.main.async {
            skpMessage.send()
        }
        
        
    }
    
    
}

extension ContactSuportVC : SKPSMTPMessageDelegate {
    
    func messageSent(_ message: SKPSMTPMessage!) {
        hideLoading()
        showAlert(MSG.sucsses)
        
        
    }
    
    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        hideLoading()
        showAlert(ErrorManager.processError(error: error).msg ?? MSG.occurred)
        print(error)
    }
    
}

extension ContactSuportVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfName {
            txfEmail.becomeFirstResponder()
            return true
        }
        
        if textField == txfEmail {
            txfPassword.becomeFirstResponder()
            return true
        }
        if textField == txfPassword {
            txvInquiry.becomeFirstResponder()
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txfEmail {
            if string == " " {
                return false
            }
        }
        return true
    }
    
    
    
    
}
