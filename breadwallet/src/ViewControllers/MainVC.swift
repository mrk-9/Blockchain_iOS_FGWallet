//
//  MainVC.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class MainVC: BaseViewController {
    @IBOutlet weak var btnNewWallet: UIButton!
    @IBOutlet weak var btnRestoreWallet: UIButton!

    //private let store: Store
    
    
    
    
    @IBOutlet weak var lblLanguage: UILabel!
     let availableLanguages = Localize.availableLanguages()
     var str = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        revealViewController().panGestureRecognizer().isEnabled = false
        setupNavi()
        navigationItem.leftBarButtonItem = nil
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        revealViewController().panGestureRecognizer().isEnabled = true
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        self.navigationItem.leftBarButtonItem = nil
        btnNewWallet.boder()
        btnRestoreWallet.boder()
        setText()
        /*
            DispatchQueue.walletQueue.async
            {
                globalAPI!.walletManager.peerManager?.disconnect()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute:
                    {
                        if(globalAPI!.walletManager.wipeWallet(pin: "forceWipe")==true)
                        {
                            globalAPI!.store.trigger(name: .reinitWalletManager({}))
                            
                            
                        }
                        
                })
                
        }
        */
    }
    
    @objc func setText() {
        btnNewWallet.setTitle(Klang.new_walllet.localized(), for: .normal)
        btnRestoreWallet.setTitle(Klang.restore_walllet.localized(), for: .normal)
        lblLanguage.text = Localize.displayNameForLanguage(Localize.currentLanguage())
        
    }
    
   
    
    // MARK:- Action button
    @IBAction func didTapBtnWallet(_ sender: Any)
    {
        
        
        
        
        let newWalletVC = self.storyboard?.instantiateViewController(withIdentifier: "NewWalletVC") as! NewWalletVC
        navigationController?.pushViewController(newWalletVC, animated: true)
    } 
    
    @IBAction func didTapRestoreWallet(_ sender: Any)
    
    {
    if (globalAPI!.walletManager.noWallet == false) //если есть кош
    {
        //сначала надо остановить все процесыы а потом
        
        DispatchQueue.walletQueue.async
        {
                globalAPI!.walletManager.peerManager?.disconnect()
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute:
                {
                    if(globalAPI!.walletManager.wipeWallet(pin: "forceWipe")==true)
                    {
                        globalAPI!.store.trigger(name: .reinitWalletManager({}))
                        
                     
                    }
                    
               })
 
        }
    }
 
     
        let recoverWalletViewController = EnterPhraseViewController(store: globalAPI!.store, walletManager: globalAPI!.walletManager, reason: .setSeed(self.pushPinCreationViewForRecoveredWallet))
        self.navigationController?.pushViewController(recoverWalletViewController, animated: true)
      
        
   // } //перенести где фраза прошла проверку на валидность
        
    /*
     1)   из-за того, что мы отчистили здесь валет появляется картина от бреда для создания нового коша.
        а после ввода фразы просит пин в форме бреда, этого не должно быть. надо подумать как тут должно работать
     2)   вернуть либу для отправки писем
      3) сделать транзакшн хистори
 */
        
       
        
        //форма с вводом номера телефона для получения смс============
   //     let newWalletVC = self.storyboard?.instantiateViewController(withIdentifier: "NewWalletVC") as! NewWalletVC
    //    navigationController?.pushViewController(newWalletVC, animated: true)
        
        
        
        //создание нового кошелька==========
     /*
        guard self?.walletManager.setRandomSeedPhrase() != nil else { self?.handleWalletCreationError(); return }
        self?.store.perform(action: WalletChange.setWalletCreationDate(Date()))
        DispatchQueue.walletQueue.async {
            self?.walletManager.peerManager?.connect()
            DispatchQueue.main.async {
                //  self?.pushStartPaperPhraseCreationViewController(pin: pin)
                self?.store.trigger(name: .didCreateOrRecoverWallet)
            }
       */
            
       // let restoreVC = self.storyboard?.instantiateViewController(withIdentifier: "RestoreWallet") as! RestoreWallet
       // navigationController?.pushViewController(restoreVC, animated: true)
                
    }
    
    private var pushPinCreationViewForRecoveredWallet: (String) -> Void
    {
        return { [weak self] phrase in
            guard let myself = self else { return }
            
           // let pinCreationView = UpdatePinViewController(store: globalAPI!.store, walletManager: globalAPI!.walletManager, type: .creationWithPhrase, showsBackButton: false, phrase: phrase)
            
            
            
            
           // let submitOTP = self.storyboard?.instantiateViewController(withIdentifier: "SubmitOTPVC") as! SubmitOTPVC
           // submitOTP.strPhone = self.lblCode.text! + strPhone
           // submitOTP.strPin = strNewPin
           // UserDefaults.standard.set(strNewPin, forKey: FGuserDefault.pin)
           // self.navigationController?.pushViewController(submitOTP, animated: true)
            
            
        
            let newWalletVC = self!.storyboard?.instantiateViewController(withIdentifier: "NewWalletVC") as! NewWalletVC
            self!.navigationController?.pushViewController(newWalletVC, animated: true);
            
            
            //pinCreationView.setPinSuccess = { [weak self] _ in
                DispatchQueue.walletQueue.async
                {
                    globalAPI!.walletManager.peerManager?.connect()
                    DispatchQueue.main.async
                    {
                       globalAPI!.store.trigger(name: .didCreateOrRecoverWallet)
                    }
                }
            }
        //    myself.navigationController?.pushViewController(pinCreationView, animated: true)
        
    }
    
    @IBAction func didTapChangeLanguage(_ sender: Any) {
        let popup = Bundle.main.loadNibNamed("PopUpLanguage", owner: self, options: nil)?.first! as! PopUpLanguage
        popup.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 200)
        popup.lblEnglish.text = Localize.displayNameForLanguage("en")
        popup.lblJapan.text = Localize.displayNameForLanguage("ja")
        
        let klcPopup =  KLCPopup.init(contentView: popup)
        
        popup.tapEN = {
            self.lblLanguage.text = Localize.displayNameForLanguage("en")
            Localize.setCurrentLanguage("en")
            klcPopup?.dismiss(true)
        }
        popup.tapJP = {
            self.lblLanguage.text = Localize.displayNameForLanguage("ja")
            Localize.setCurrentLanguage("ja")
            klcPopup?.dismiss(true)
        }
        klcPopup?.showType = .bounceIn
        klcPopup?.dismissType = .bounceOut
        
        klcPopup?.show()

    }
    
}
