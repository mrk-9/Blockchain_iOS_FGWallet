//
//  SendVC.swift
//  FGWallet
//
//  Created by Ivan on 1/8/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
fileprivate let min_withdrawal = " 0.000010 BTC"
class SendVC: BaseViewController {
    
    
    @IBOutlet weak var lblCurentInfo: UILabel!
    
    @IBOutlet weak var lblRecipient: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    
    @IBOutlet weak var lblConvertToJPY: UILabel!
    
    @IBOutlet weak var imgCamera: UIImageView!
    
    @IBOutlet weak var txfRecipient: BaseTextField!
    
    @IBOutlet weak var txfBTC: BaseTextField!
    
    @IBOutlet weak var txfJPY: BaseTextField!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var txfMemo: BaseTextField!
    
    
    @IBOutlet weak var viewBTC: UIView!
    
    @IBOutlet weak var viewJPY: UIView!
    @IBOutlet weak var bottomScroolView: NSLayoutConstraint!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    @IBOutlet weak var lblTextInfo: UILabel!
    var codeQR: String? = nil
    
    var rate: Double = 0
    var totalAmount: Double = 0
    
    let keyboard = KUIKeyboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        navigationItem.title = Klang.send.localized()
        lblCurentInfo.text = Klang.current_balance.localized()
        lblRecipient.text = Klang.recipient.localized()
        lblAmount.text = Klang.amount.localized()
        lblMemo.text = Klang.memo.localized()
        btnContinue.setTitle(Klang.continueT.localized(), for: .normal)
        self.activity.isHidden = true
        imgCamera.image = #imageLiteral(resourceName: "icamera").withRenderingMode(.alwaysTemplate)
        imgCamera.tintColor = .white
       
        btnContinue.boder()
        btnCamera.boder()
        addBackButton()
        addToolBar(txfBTC)
        addToolBar(txfJPY)
        addToolBar(txfRecipient)
        addToolBar(txfMemo)
        addTapDismiss()
        lblTotalAmount.text = "\(totalAmount.formatBTC()) BTC"
        lblConvertToJPY.text = "￥ \((totalAmount * rate).formatJPY())"
        txfJPY.clearButtonMode = .never
        txfBTC.clearButtonMode = .never
        keyboard.onChangedKeyboardHeight = { [weak self] (visibleHeight) in
            guard let strongSelf = self else {return}
            strongSelf.bottomScroolView.constant = visibleHeight
            strongSelf.view.layoutIfNeeded()
            
        }
        lblTextInfo.text = Klang.min_withdrawal.localized() + min_withdrawal
        lblTextInfo.textColor = .red
        
        
        txfRecipient.text = codeQR
        txfRecipient.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
        txfJPY.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
        txfBTC.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        if let text = txfRecipient.text, !text.isEmpty {
            setEnablerTextConvert(true)
            
        }else{
            setEnablerTextConvert(false)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setEnablerTextConvert(_ isEnabler: Bool) {
        if isEnabler == true {
            txfBTC.isEnabled = true
            txfJPY.isEnabled = true
            txfBTC.textColor = .black
            txfJPY.textColor = .black
            
        }else{
            txfBTC.isEnabled = false
            txfJPY.isEnabled = false
            txfBTC.textColor = .gray
            txfJPY.textColor  = .gray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        revealViewController().panGestureRecognizer().isEnabled = false
        keyboard.addObservers()
        
    }
    
    func requestFeet(_ address: String, amount: Double)
    {
        activity.startAnimating()
        activity.isHidden = false
        self.lblTextInfo.text = ""
        globalAPI?.caculate_fee(address.subStringBitcon(), amount: amount) { (blank, feet, err) in
            self.activity.stopAnimating()
            self.activity.isHidden = true
            guard err == nil else {
                self.lblTextInfo.text = "\(Klang.balance_minus_fee.localized()) \(self.totalAmount.formatBTC()) BTC\n\(Klang.send_network_fee.localized()) 0 BTC"
                self.lblTextInfo.textColor = FGColor.accent
                return
            }
            if let blank = blank, let feet = feet {
                let caculation =  blank - feet
                if caculation <= feet {
                    self.lblTextInfo.text = "\(Klang.balance_minus_fee.localized()) 0 BTC\n\(Klang.send_network_fee.localized()) \(feet.formatBTC()) BTC"
                }else {
                    self.lblTextInfo.text = "\(Klang.balance_minus_fee.localized()) \(caculation.formatBTC()) BTC\n\(Klang.send_network_fee.localized()) \(feet.formatBTC()) BTC"
                }
                self.lblTextInfo.textColor = FGColor.accent
            }else{
                self.lblTextInfo.text = "\(Klang.balance_minus_fee.localized()) \(self.totalAmount.formatBTC()) BTC\n\(Klang.send_network_fee.localized()) 0 BTC)"
                self.lblTextInfo.textColor = FGColor.accent
               
            }
            
        }
    }
    
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField == txfRecipient {
            guard let text = txfRecipient.text, !text.isEmpty else {
                setEnablerTextConvert(false)
                return
            }
            
            setEnablerTextConvert(true)
            if let btcStr = txfBTC.text, !btcStr.isEmpty, let value = Double(btcStr), value >= 0.000010{
                if let address = txfRecipient.text, !address.isEmpty {
                    requestFeet(address, amount: value)
                }
                
                
            }else{
                txfJPY.text = "0"
                lblTextInfo.text = Klang.min_withdrawal.localized() + min_withdrawal
                lblTextInfo.textColor = FGColor.red
            }
        }
        if textField == txfBTC {
            if let btcStr = txfBTC.text, !btcStr.isEmpty, let value = Double(btcStr), value >= 0.000010{
                
                lblTextInfo.textColor = .green
                txfJPY.text = "\((value * rate).formatJPY())"
                if let address = txfRecipient.text, !address.isEmpty {
                    requestFeet(address, amount: value)
                }
                
                
            }else{
                txfJPY.text = "0"
                lblTextInfo.text = Klang.min_withdrawal.localized() + min_withdrawal
                lblTextInfo.textColor = FGColor.red
            }
            return
        }
        
        if textField == txfJPY {
            if let jpyStr = txfJPY.text, !jpyStr.isEmpty, let value = Double(jpyStr) {
                let btc = value / rate
                txfBTC.text = "\(btc.formatBTC())"
                if btc >= 0.000010, let address = txfRecipient.text, !address.isEmpty {
                    requestFeet(address, amount: btc)
                }
                
            }else {
                txfBTC.text = "0"
                lblTextInfo.text = Klang.min_withdrawal.localized() + min_withdrawal
                lblTextInfo.textColor = FGColor.red
            }
            
        }
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        revealViewController().panGestureRecognizer().isEnabled = true
        keyboard.removeObservers()
    }
    
    @IBAction func didTapCamera(_ sender: Any) {
        let scanVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanQRVC") as! ScanQRVC
        scanVC.getcode = {[weak self] code in
            self?.txfRecipient.text = code
            self?.txfBTC.isEnabled = true
            self?.txfJPY.isEnabled = true
            self?.lblTextInfo.text = Klang.min_withdrawal.localized() + min_withdrawal
            self?.lblTextInfo.textColor = FGColor.red
        }
        present(UINavigationController.init(rootViewController: scanVC), animated: true, completion: nil)
        
    }
    
    @IBAction func didTapRefershBalance(_ sender: Any)
    {
       // guard FGuserDefault.getToken().count > 0 else {
        //    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
       //     self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: mainVC), animated: true)
       //     return
       // }
        
        showLoading()
        
        API.getConvertMoney({ (value) in
            hideLoading()
            var toaltal = 0.00000000
            
            let balance = globalAPI?.getBalance()
          //  let addr = globalAPI?.getAddr()
            toaltal = Double(balance!) / 100000000
            
            
            self.totalAmount = toaltal
            self.lblTotalAmount.text = "\(toaltal.formatBTC()) BTC"
          //  self.lblAdress.text = addr
            //self.imageQR.image = (addr ?? "").generateQRCode()
            if let value = value {
                self.rate = value
                
                
                self.lblConvertToJPY.text = "￥ \((toaltal * value).formatJPY())"
            }else{
                self.lblConvertToJPY.text = "￥"
                self.rate = 0
            }
            
        })
    }
   /*
        showLoading()
        API.balance { (json, error) in
            
            
            guard error == nil else {
                hideLoading()
                self.showAlert(error!.msg ?? MSG.occurred)
                return
            }
            API.getLastAndress({ (jsonAdrees, err) in
                
                guard error == nil else {
                    hideLoading()
                    self.showAlert(error!.msg ?? MSG.occurred)
                    return
                }
                API.getConvertMoney({ (value) in
                    hideLoading()
                    var toaltal = 0.00000000
                    if let available_balance = json!["data"]["address"]["available_balance"].string {
                        toaltal = Double(available_balance)!
                    }
                    
                    if let reamin = json!["data"]["address"]["pending_received_balance"].string {
                        toaltal += Double(reamin)!
                    }
//                    var unit = ""
//                    if let network = json!["data"]["address"]["network"].string {
//                        unit = network
//                    }
                    
                    self.totalAmount = toaltal
                    self.lblTotalAmount.text = "\(toaltal.formatBTC()) BTC"
                  
                    if let value = value {
                        self.rate = value
                        
                        
                        self.lblConvertToJPY.text = "￥ \((toaltal * value).formatJPY())"
                    }else{
                        self.lblConvertToJPY.text = "￥"
                        self.rate = 0
                    }
                })
                
            })
            
        }
        
    }
*/
    @IBOutlet weak var didTapRefesh: UIButton!
    
    
    @IBAction func didTapContinue(_ sender: Any) {
        guard let address = txfRecipient.text, !address.isEmpty else {
            showAlert(MSG.recipientRequired)
            return
        }
        
        guard let strBTC = txfBTC.text, !strBTC.isEmpty, let btc = Double(strBTC) else {
           viewBTC.shake()
            return
        }
//        guard let memo = txfMemo.text, !memo.isEmpty else {
//            showAlert(MSG.memoRequired)
//            return
//        }
        
     //  showLoading()
       //  self.didTapRefershBalance(self.didTapRefesh)
        
        globalAPI?.parentViewController = self
        globalAPI?.sendBTC(address, amount: btc, memo: txfMemo.text) { (error) in
            hideLoading()
            if let error = error {
                self.showAlert(error.msg ?? MSG.occurred)
            }else{
                self.showAlert("Success")
                self.didTapRefershBalance(self.didTapRefesh)
              
            }
        }
        
    }
    
}

extension SendVC: UITextFieldDelegate {
    
    
}
