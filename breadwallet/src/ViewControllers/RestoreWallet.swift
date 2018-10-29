//
//  RestoreWallet.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import SafariServices

class RestoreWallet: BaseViewController {
    
    @IBOutlet weak var lblMobilenumber: UILabel!
    @IBOutlet weak var lblYourPin: UILabel!
    
    @IBOutlet weak var lblNeedHelp: UILabel!
    
    @IBOutlet weak var viewPhone: UIView!
    
    @IBOutlet weak var viewPin: UIView!
    @IBOutlet weak var lblIsoCode: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var txfPhone: BaseTextField!

    @IBOutlet weak var txfPin: BaseTextField!
    
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var bottomScroll: NSLayoutConstraint!
   
    let keyboard = KUIKeyboard()
    var country = Country.init(name: "Japan", isoCode: "JP", callingCode: "+81")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        settext()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        revealViewController().panGestureRecognizer().isEnabled = false
        keyboard.addObservers()
    }
    
    func settext() {
        btnRestore.setTitle(Klang.restore_walllet.localized(), for: .normal)
        lblMobilenumber.text = Klang.mobile_number.localized()
        lblYourPin.text = Klang.your_pin.localized()
        lblNeedHelp.text = Klang.need_help.localized()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        revealViewController().panGestureRecognizer().isEnabled = true
        keyboard.removeObservers()
    }
    
    private func setup() {
        addBackButton()
        btnRestore.boder()
        addTapDismiss()
      
        addToolBar(txfPhone)
        addToolBar(txfPin)
        lblIsoCode.text = country.isoCode
        lblCode.text = country.callingCode
        keyboard.onChangedKeyboardHeight = { [weak self] (visibleHeight) in
            guard let strongSelf = self else {return}
            strongSelf.bottomScroll.constant = visibleHeight
            strongSelf.view.layoutIfNeeded()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func didTapCountrySelect(_ sender: Any) {
        view.endEditing(true)
         let countryPickerView = CountryPickerViewController()
        countryPickerView.delegate = self
        
        let navigationController = UINavigationController(rootViewController: countryPickerView)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func didTapBtnRestoreWallet(_ sender: Any) {
       
        guard let strPhone = txfPhone.text, !strPhone.isEmpty else {
            viewPhone.shake()
            return
        }
        
        guard let strPin = txfPin.text, !strPin.isEmpty else {
            viewPin.shake()
            return
            
        }

        
        showLoading()
        API.login(country.callingCode + strPhone, pin: strPin) { (token, pharse, err) in
            hideLoading()
            if err == nil {
                let recoveryPharse = self.storyboard?.instantiateViewController(withIdentifier: "RecoveryPharseVC") as! RecoveryPharseVC
                if let pharse = pharse {
                    recoveryPharse.pharsetext = pharse
                }
                self.navigationController?.pushViewController(recoveryPharse, animated: true)
            }else{
                self.showAlert(err?.msg ?? MSG.occurred)
            }
        }
        
    }
    
    

    @IBAction func didTapBtnNeedHelp(_ sender: Any) {
//        let svc = SFSafariViewController.init(url: URL.init(string: "http://google.com")!)
//        svc.modalPresentationStyle = .overFullScreen
//        svc.delegate = self
//      
//        present(svc, animated: true) {
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    
    
}
extension RestoreWallet: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

extension RestoreWallet: CountryPickerViewControllerDelegate {
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
