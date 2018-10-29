//
//  SubmitOTPVC.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class SubmitOTPVC: BaseViewController {
    
    @IBOutlet weak var lblTitleEnterTheOTP: UILabel!
    
    @IBOutlet weak var lblEnterOTP: UILabel!
    
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var bottomScrollView: NSLayoutConstraint!
    let keyboard = KUIKeyboard()
    @IBOutlet weak var txfOTP: BaseTextField!
    
    var strPhone = ""
    var strPin = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func setup() {
        
        keyboard.onChangedKeyboardHeight = { [weak self] (visibleHeight) in
            guard let strongSelf = self else {return}
            strongSelf.bottomScrollView.constant = visibleHeight
            strongSelf.view.layoutIfNeeded()
            
        }
        addToolBar(txfOTP)
        btnResend.boder()
        btnSubmit.boder()
        lblTitleEnterTheOTP.text = Klang.msg_manual_otp.localized()
        lblEnterOTP.text = Klang.enter_otp.localized()
        btnSubmit.setTitle(Klang.submit.localized(), for: .normal)
        btnResend.setTitle(Klang.resend.localized(), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        revealViewController().panGestureRecognizer().isEnabled = false
         setupNavi()
        addBackButton()
        keyboard.addObservers()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        revealViewController().panGestureRecognizer().isEnabled = true
        keyboard.removeObservers()
    }

    @IBAction func didTapBtnSubMit(_ sender: Any) {
        
//        guard let oTP = txfOTP.text, !oTP.isEmpty else {
//            viewOtp.shake()
//            return
//        }
//        showLoading()
//        globalAPI?.create(strPhone, pin: strPin, code: oTP) { (error) in
//            hideLoading()
//
//            guard  error == nil else {
//                self.showAlert(error!.msg ?? MSG.occurred)
//                return
//            }
        
            let showRecoveryVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowRecoveryPhaseVC") as! ShowRecoveryPhaseVC
            
            self.navigationController?.pushViewController(showRecoveryVC, animated: true)
            
//        }
    }
    
    @IBAction func didTapBtnResend(_ sender: Any) {
//        API.verification(strPhone) { (success, error) in
//            hideLoading()
//            if error == nil {
//
//            }else {
//                self.showAlert(error?.msg ?? MSG.occurred)
//
//            }
//
//        }
//
        
    }


}
