//
//  API.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import BRCore

class API {
    
   
    
    init(walletManager: WalletManager, store: Store) {
        
        self.store = store
        self.walletManager = walletManager
    
    }
    
    public let walletManager: WalletManager
   
    public let store: Store
    
    var transaction: BRTxRef?
    var protocolRequest: PaymentProtocolRequest?
    var rate: Rate?
    var comment: String?
    var feePerKb: UInt64?
    
    var new_pin: String?
    
    
  var parentViewController:UIViewController!
    
    
    func createTransaction(amount: UInt64, to: String) -> Bool
    {
        guard let wallet = walletManager.wallet else { return false}
        let addresses = wallet.allAddresses.filter({wallet.addressIsUsed($0)})
        
       
        
        transaction = walletManager.wallet?.createTransaction(forAmount: amount, toAddress: to)
        return transaction != nil
    }
    
func getPhrase() -> String
{
     guard let phraseString = walletManager.seedPhrase(pin: "") else { return ""}
    
    return phraseString
    

}
    
    func getBalance() -> UInt64
    {
      // guard let newBalance = self.walletManager.wallet?.balance else { return 1}
       
          guard let wallet = walletManager.wallet else { return 1}
        
         let newBalance = wallet.balance
        
        return newBalance
        
        
    }
    
    func getAddr() -> String
    {
        
        guard let wallet = walletManager.wallet else { return ""}
        
       
        
        let btcAddr = wallet.receiveAddress
        
    
        
        return btcAddr
        
        
    }
    
    /*
    func createTransaction(amount: UInt64, to: String) -> Bool
    {
        transaction = walletManager.wallet?.createTransaction(forAmount: amount, toAddress: to)
        return transaction != nil
    }
 
    func sendBTCtoAddr()
    {
        
        
 
    }
 */

  /*  private func handleWalletCreationError() {
        let alert = UIAlertController(title: S.Alert.error, message: "Could not create wallet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: S.Button.ok, style: .default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    */
    func createNewWallet() ->Bool
    {
    
        guard walletManager.setRandomSeedPhrase() != nil else
        {
            
            
            
          //  complete( ErrorManager.processError(errorMsg:"Could not create wallet"))
           
            
            return false
            
        }
        store.perform(action: WalletChange.setWalletCreationDate(Date()))
        DispatchQueue.walletQueue.async {
            self.walletManager.peerManager?.connect()
            DispatchQueue.main.async {
                //  self?.pushStartPaperPhraseCreationViewController(pin: pin)
                self.store.trigger(name: .didCreateOrRecoverWallet)
            }
        }
        return true;
    }
    
     func verification(_ phone: String, reset: Bool = false, complete:@escaping (_ sucsses: Bool?, _ eror: ErrorModel?) ->()) {
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        
       
        let url = FG_Url.getRequest(FG_Url.verification)
        let para: Parameters = ["phone": phone,
                                "deviceId": device_id]
        print(para)
        
        
      
        
     
        
        let headers = [
            "Authorization": "Auth AC61a6b28a82e32bf3818df5fd1d5caf06",
            "Content-Type": "application/json"
        ]
     
      
      let request =  Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else
                    {
                        complete(false, ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    if let finish = JSON(value)["status"].string, finish == "Success"
                    {
                        complete(true, nil)
                        return
                    }
                    else
                    {
                   
                        
                        complete(false,  ErrorManager.processError(errorMsg: JSON(value)["status"].string ?? MSG.occurred))
                    }
                
                case .failure(let error):
                    complete(nil, ErrorManager.processError(error: error))
                    
                }
                
        }
          print(request)
 
        
    }
   
  
     func create(_ phone: String, pin: String, code: String, complete:@escaping (_ err: ErrorModel?) ->()) {
        
        
        guard let wallet = walletManager.wallet else { return }
        
       //  guard let strPh = setRandomSeedPhrase() else { return }
        
      //  guard let str = walletManager.setRandomSeedPhrase() else { return }
        
        
        let btcAddr = wallet.receiveAddress
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let url = FG_Url.getRequest(FG_Url.create)
        let para: Parameters = ["phone": phone,
                                "bitcoinAddress": btcAddr,
                                "pin": pin,
                                "code": code,
                                "deviceId": device_id ]
 
 
        
        let headers = [
            "Authorization": "Auth AC61a6b28a82e32bf3818df5fd1d5caf06",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                  
                case .success(_):

                    guard let value = response.result.value else
                    {
                        complete(ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    if let finish = JSON(value)["status"].string, finish == "Success"
                    {
                     
                    
                        self.new_pin = pin
                        
                        
                        //save pin to reg====
                        let pin = globalAPI?.new_pin
                        
                        UserDefaults.standard.set(pin, forKey: FGuserDefault.pin)
                        
                        
                        complete(nil)
                    }
                    else
                    {
                                complete(ErrorManager.processError(errorMsg: JSON(value)["status"].string ?? MSG.occurred))
                    }
               
                    
        
                
                case .failure(let error):
                    complete(ErrorManager.processError(error: error))
                    
                }
                
                
        }
        
    }
  
    
   
    
    //===================OLD================ DOES NOT WORK NOW
    static func login(_ phone: String, pin: String, complete:@escaping (_ token: String?, _ pharsetext: String?, _ err: ErrorModel?) ->()) {
        let url = FG_Url.getRequest(FG_Url.login)
        let para: Parameters = ["phone": phone,
                                "pin": pin]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete(nil, nil, ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    if let token = JSON(value)["data"]["api_token"].string {
                        UserDefaults.standard.setValue(token, forKey: FGuserDefault.token)
                        UserDefaults.standard.set(phone, forKey: FGuserDefault.phone)
                        UserDefaults.standard.set(pin, forKey: FGuserDefault.pin)
                        if let recovery = JSON(value)["data"]["recovery_phrase"].string {
                            UserDefaults.standard.set(recovery, forKey: FGuserDefault.recoveryPhase)
                        }
                        UserDefaults.standard.synchronize()
                        complete(token, JSON(value)["data"]["recovery_phrase"].string, nil)
                    }else{
                        complete(nil, nil, ErrorManager.processError(errorMsg: JSON(value)["data"]["message"].string ?? MSG.occurred))
                    }
                    
                    
                    
                case .failure(let error):
                    complete(nil, nil, ErrorManager.processError(error: error))
                    
                }
                
        }
        
    }
    
    static func balance(_ complete:@escaping (_ json: JSON? , _ err: ErrorModel?) ->()) {
        let url = FG_Url.getRequest(FG_Url.balance)
        let token = FGuserDefault.getToken()
        guard token.count > 0 else {
            complete(nil, ErrorManager.processError(errorMsg: MSG.occurred))
            return
        }
        
        let para: Parameters = ["api_token": token]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete(nil, ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    complete(JSON(value), nil)
                    
                    
                    
                    
                case .failure(let error):
                    complete(nil, ErrorManager.processError(error: error))
                    
                }
                
        }
        
    }
    
    
    static func getConvertMoney(_ complete:@escaping (_ rate: Double?) ->()) {
        let url = URL.init(string: FG_Url.converMoney)!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete(nil)
                        return
                    }
                    if let rateValue = JSON(value)["bpi"]["JPY"]["rate_float"].double {
                        complete(rateValue)
                        return
                    }else{
                        complete(nil)
                    }
                    
                    
                    
                    
                    
                case .failure( _):
                    complete(nil)
                    
                }
                
        }
        
    }
    
    static func getCureentPrice(_ complete:@escaping (_ rate: Double?, _ date: Date?, _ err: ErrorModel?) ->()) {
        let url = URL.init(string: FG_Url.converMoney)!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete(nil, nil, ErrorManager.processError(errorMsg: MSG.occurred) )
                        return
                    }
                    if let rateValue = JSON(value)["bpi"]["JPY"]["rate_float"].double {
                       
                        if let strDate = JSON(value)["time"]["updatedISO"].string, let dateCurent = strDate.dateFromISO8601{
                          
                            complete(rateValue,dateCurent, nil)
                            return
                            
                        }
                        
                        complete(rateValue, nil, nil)
                        return
                    }else{
                        complete(nil, nil, ErrorManager.processError(errorMsg: MSG.occurred))
                    }
                    
                    
                    
                    
                    
                case .failure(let error):
                    complete(nil, nil, ErrorManager.processError(error: error))
                    
                }
                
        }
        
    }
    

    
    static func getChart(_ dateCurrent: Date?, _ complete:@escaping ([(Date, Double)], _ error: ErrorModel?) ->()) {
       
        let earlyDate = Calendar.current.date(
            byAdding: .day,
            value: -30,
            to: dateCurrent ?? Date())
    
        let url = URL.init(string: FG_Url.getChart + FormatDate.string(from: earlyDate!))!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete([], ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    if let rateValue = JSON(value)["dataset"]["data"].array, rateValue.count > 0 {
                        let resulft = rateValue.flatMap { (obj) -> (Date, Double) in
                            let date = FormatDate.date(from: obj.arrayValue[0].string!)
                            let value = obj.arrayValue[1].double!

                            return (date!, value)
                        }
                       
                        complete(resulft.reversed(), nil)
                        return
                       
                    }else{
                        complete([], ErrorManager.processError(errorMsg: JSON(value)["data"]["message"].string ?? MSG.occurred))
                    }
                    
                    
                    
                    
                    
                case .failure(let error):
                    complete([], ErrorManager.processError(error: error))
                    
                }
                
        }
        
    }
    
    
    
    
    static func getLastAndress(_ complete:@escaping (_ address: String? , _ err: ErrorModel?) ->()) {
        let url = FG_Url.getRequest(FG_Url.last_address)
        let token = FGuserDefault.getToken()
        guard token.count > 0 else {
            complete(nil, ErrorManager.processError(errorMsg: MSG.occurred))
            return
        }
        
        let para: Parameters = ["api_token": token]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete(nil, ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    if let address = JSON(value)["data"]["address"]["address"].string {
                        complete(address, nil)
                        return
                    }else{
                        complete(nil, ErrorManager.processError(errorMsg: JSON(value)["data"]["message"].string ?? MSG.occurred))
                    }
                    
                    
                    
                    
                    
                case .failure(let error):
                    complete(nil, ErrorManager.processError(error: error))
                    
                }
                
        }
        
    }
    
    static func creatNewAddress(_ complete:@escaping (_ address: String? , _ err: ErrorModel?) ->()) {
        let url = FG_Url.getRequest(FG_Url.new_address)
        let token = FGuserDefault.getToken()
        guard token.count > 0 else {
            complete(nil, ErrorManager.processError(errorMsg: MSG.occurred))
            return
        }
        
        let para: Parameters = ["api_token": token]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete(nil, ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    if let address = JSON(value)["data"]["address"]["address"].string {
                        complete(address, nil)
                        return
                    }else{
                        complete(nil, ErrorManager.processError(errorMsg: JSON(value)["data"]["message"].string ?? MSG.occurred))
                    }
                    
                    
                    
                    
                    
                case .failure(let error):
                    complete(nil, ErrorManager.processError(error: error))
                    
                }
                
        }
        
    }
    
    static func getTransion(_ complete:@escaping (_ historys: [History] , _ err: ErrorModel?) ->()) {
        let url = FG_Url.getRequest(FG_Url.history)
        let token = FGuserDefault.getToken()
        guard token.count > 0 else {
            complete([], ErrorManager.processError(errorMsg: MSG.occurred))
            return
        }
        
        let para: Parameters = ["api_token": token]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        complete([], ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    if let json = JSON(value)["data"]["history"].array {
                        complete(json.flatMap({History.init($0)}), nil)
                        return
                    }
                    complete([], ErrorManager.processError(errorMsg: JSON(value)["data"]["message"].string ?? MSG.occurred))
                    
                    
                    
                    
                    
                case .failure(let error):
                    complete([],  ErrorManager.processError(error: error))
                    
                }
                
        }
        
    }
    
     func caculate_fee(_ address: String, amount: Double, complete:@escaping (_ activeBlank: Double?, _ networkFedd: Double?, _ error: ErrorModel?) ->())
     
     {
        //guard let walletManager = walletManager else { return nil }
        guard let kvStore = walletManager.apiClient?.kv else { return }
        
        let sender: Sender
        
        sender = Sender(walletManager: walletManager, kvStore: kvStore, store: store)
    //     [weak self] amount
        
     //   amount: Satoshis?
         let rawValue: UInt64
        rawValue = ((UInt64)(amount * 100000000))
        let fee = sender.feeForTx(amount: rawValue)
        
        
        guard let newBalance = self.walletManager.wallet?.balance else { return }
        
        
        
        //возвращаем доступный баланс и комиссию
         let cur_balance: Double
         let cur_balance_satoshi: Double
        
        let fee_satoshi: Double
        let fee_btc: Double
        
        fee_satoshi = Double(fee)
        
        cur_balance_satoshi = Double(newBalance)
        
        cur_balance = Double(cur_balance_satoshi/100000000);
        
        fee_btc = Double(fee_satoshi/100000000);
        
        complete(cur_balance, fee_btc, nil)
        
    }
    
     func sendBTC(_ address: String, amount: Double, memo: String?, complete:@escaping (_ error: ErrorModel?) ->()) {
        
        let sender: Sender
        
        guard let kvStore = walletManager.apiClient?.kv else { return }
        
        sender = Sender(walletManager: walletManager, kvStore: kvStore, store: store)
         let amount_sat : UInt64
        amount_sat = UInt64(amount * 100000000)
        
        if sender.transaction == nil
        {
          //  guard let address = address else {
           //     return showAlert(title: S.Alert.error, message: S.Send.noAddress, buttonLabel: S.Button.ok)
          //  }
            guard address.isValidAddress else
            {
                 complete(ErrorManager.processError(errorMsg: S.Send.invalidAddressMessage))
                   return
                //showAlert(title: S.Send.invalidAddressTitle, message: S.Send.invalidAddressMessage, buttonLabel: S.Button.ok)
            }
           // guard let amount = amount else {
            //    return showAlert(title: S.Alert.error, message: S.Send.noAmount, buttonLabel: S.Button.ok)
           // }
            
           
            
            
            if let minOutput = walletManager.wallet?.minOutputAmount
            {
                guard amount_sat >= minOutput
                    else
                {
                    let rate = store.state.currentRate
                   // let minOutputAmount = Amount(amount: minOutput, rate: Rate.empty, maxDigits: store.state.maxDigits)
                    let minOutputAmount = Amount(amount: minOutput, rate: rate!, maxDigits: store.state.maxDigits)
                    let message = String(format: S.PaymentProtocol.Errors.smallPayment, minOutputAmount.string(isBtcSwapped: true))
                    
                    complete(ErrorManager.processError(errorMsg: message))
                    return;
                   // return showAlert(title: S.Alert.error, message: message, buttonLabel: S.Button.ok)
                }
            }
            guard !(walletManager.wallet?.containsAddress(address) ?? false) else
            {
                complete(ErrorManager.processError(errorMsg: S.Send.containsAddress))
                return;
                //return showAlert(title: S.Alert.error, message: S.Send.containsAddress, buttonLabel: S.Button.ok)
            }
            guard amount_sat <= (walletManager.wallet?.maxOutputAmount ?? 0)
                else {
               // return showAlert(title: S.Alert.error, message: S.Send.insufficientFunds, buttonLabel: S.Button.ok)
            complete(ErrorManager.processError(errorMsg: S.Send.insufficientFunds))
                    return;
                    
            }
            guard sender.createTransaction(amount: amount_sat, to: address)
                else {
                      complete(ErrorManager.processError(errorMsg: S.Send.createTransactionError))
                    return;
                    //return showAlert(title: S.Alert.error, message: S.Send.createTransactionError, buttonLabel: S.Button.ok)
            }
        }
        
       // Rate myRate{"1", "2", 0.1};
        
        let rate = store.state.currentRate
        
        //UInt64 sat_amount = amount * 100000000
        
         var newAmount: Satoshis
        let bitcoin = Bitcoin(rawValue: amount)
        newAmount = Satoshis(bitcoin: bitcoin)
        
        
        let confirm = ConfirmationViewController(amount: newAmount, fee: Satoshis(sender.fee), feeType: .regular, state: store.state, selectedRate: rate, minimumFractionDigits: 0, address: address ?? "", isUsingTouchId: sender.canUseTouchId)
        confirm.successCallback = {
            confirm.dismiss(animated: true, completion:
            {
                //===============================SENDING===================================================
             
                guard let rate = self.store.state.currentRate else { return }
                guard let feePerKb = self.walletManager.wallet?.feePerKb else { return }
      
                /*
 
func send(touchIdMessage: String, rate: Rate?, comment: String?, feePerKb: UInt64, verifyPinFunction: @escaping (@escaping(String) -> Bool) -> Void, completion:@escaping (SendResult) -> Void) {
 
 */
                
                sender.send(touchIdMessage: S.VerifyPin.touchIdMessage,
                            rate: rate,
                            comment: memo,
                            feePerKb: feePerKb,
                            
                            //verifyPinFunction: Void
                    /*{
                                [ weak self] pinValidationCallback in
                                self?.presentVerifyPin?(S.VerifyPin.authorize)
                                {
                                    [weak self] pin, vc in
                                    if pinValidationCallback(pin) {
                                        vc.dismiss(animated: true, completion: {
                                            self?.parent?.view.isFrameChangeBlocked = false
                                        })
                                        return true
                                    } else {
                                        return false
                                    }
                                }
                              //  return true
 */
                    completion: { [weak self] result in
                        switch result {
                        case .success:
                            complete( nil)
                            return
                                //  complete(ErrorManager.processError(errorMsg: S.Send.createTransactionError))
                         //   return;
                            /*  self?.parentViewController.dismiss(animated: true, completion:
                            {
                                guard let myself = self?.parentViewController else { return }
                                
                                myself.store.trigger(name: .showStatusBar)
                                if myself.isPresentedFromLock {
                                    myself.store.trigger(name: .loginFromSend)
                                }
                                myself.onPublishSuccess?()
                            })
 */
                           // self?.saveEvent("send.success")
                            
                        case .creationError(let message):
                        
                            complete(ErrorManager.processError(errorMsg: message))
                               return;
                        
                          
                            
                        case .publishFailure(let error):
                            if case .posixError(let code, let description) = error
                            {
                                complete(ErrorManager.processError(errorMsg: "\(description) (\(code))"))
                                return;
                                
                               
                                
                               // self?.saveEvent("send.publishFailed", attributes: ["errorMessage": "\(description) //(\(code))"])
                            }
                        }
                })
                //=========================================================================================
                //  self.send()
            }
            
            )
        }
        confirm.cancelCallback = {
            confirm.dismiss(animated: true, completion: {
               sender.transaction = nil
            })
        }
         let confirmTransitioningDelegate = PinTransitioningDelegate()
        
        confirmTransitioningDelegate.shouldShowMaskView = false
        confirm.transitioningDelegate = confirmTransitioningDelegate
        confirm.modalPresentationStyle = .overFullScreen
        confirm.modalPresentationCapturesStatusBarAppearance = true
        parentViewController.present(confirm, animated: true, completion: nil)
        
    
//===================================================================================
       
        
    }
 

    
    
    static func changePassword(_ oldPIN: String, newPIN: String, complete:@escaping (_ error: ErrorModel?) ->())
    
    {
        
     
        
        
        complete( nil)
        return
        
        
        //   complete(ErrorManager.processError(errorMsg: MSG.occurred))
      //  return
        
       /*
        let url = FG_Url.getRequest(FG_Url.change_pin)
        let token = FGuserDefault.getToken()
        guard  token.count > 0 else {
            complete(ErrorManager.processError(errorMsg: MSG.occurred))
            return
        }
        
        
        let para: Parameters = ["api_token": token,
                                "old_pin": oldPIN,
                                "new_pin": newPIN]
      
        print(url)
        print(para)
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                    
                case .success(_):
                    guard let value = response.result.value else {
                        
                        complete(ErrorManager.processError(errorMsg: MSG.occurred))
                        return
                    }
                    
                    
                    if let _ = JSON(value)["data"]["user_id"].int {
                        complete( nil)
                        return
                    }
                    
                    complete(ErrorManager.processError(errorMsg: JSON(value)["data"]["message"].string ?? MSG.occurred))
                    
                    
                    
                    
                case .failure(let error):
                    complete( ErrorManager.processError(error: error))
                    
                }
                
        }
 
 */
        
    }
    
    
    
    
    
    
}
