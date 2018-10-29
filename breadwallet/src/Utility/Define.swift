//
//  Define.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

let APPName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""

enum FGWalletError: Int {
    case INVALID_DATA_PROVIDED      = 9
    case INVALID_USER               = 10
    case INVALID_PIN                = 11
    case INVALID_OLD_PIN            = 12
    case CODE_ALREADY_SENT          = 30
    case USER_ALREADY_EXISTS        = 32
    case WRONG_CODE                 = 31
    
    
}

let FormatDate: DateFormatter = {
    let fm = DateFormatter()
    fm.dateFormat = "yyyy-MM-dd"
    return fm
}()



struct FGuserDefault {
    static let token = "TOKEN"
    static let phone = "PHONE"
    static let pin   = "PIN"
    static let recoveryPhase = "RECOVERY_PHASE"
    static let address       = "ADDRESS"
    static let is_InputRecoveryPhase =  "INPUT_RECOVERY_PHASE"
    static func removeAllValue() {
        UserDefaults.standard.removeObject(forKey: token)
        UserDefaults.standard.removeObject(forKey: phone)
        UserDefaults.standard.removeObject(forKey: pin)
        UserDefaults.standard.removeObject(forKey: recoveryPhase)
        UserDefaults.standard.removeObject(forKey: is_InputRecoveryPhase)
        UserDefaults.standard.synchronize()
    }
    
    static func getToken() -> String {
        if let strToken = (UserDefaults.standard.value(forKey: token) as? String) {
            return strToken
        }
        return ""
    }
    
    static func check_InputRecoveryPhase() -> Bool
    {
        if let input = (UserDefaults.standard.value(forKey: is_InputRecoveryPhase) as? Bool) {
            return input
        }
        return false
        
    }
    
    static func getRecoveryPhase() -> String {
        if let recoveryPhase = (UserDefaults.standard.value(forKey: recoveryPhase) as? String) {
            return recoveryPhase
        }
        return ""
    }
}


struct EmailSuport {
    static let send           = "fg.wallet@yandex.ru"
    static let revice         = "android@financial-gate.info"
    
  //  static let revice         = "fg.wallet@yandex.ru"
    
    //    static let revice         = "hoangdieu.tkht@gmail.com"
    static let password       = "FGWALLET"
    static let hostName       = "smtp.yandex.ru"
    static let subject        = "Contact Support"
}
 
 


/*
struct EmailSuport {
    static let send           = "fgwallet@yandex.com"
    static let revice         = "android@financial-gate.info"
    //    static let revice         = "hoangdieu.tkht@gmail.com"
    static let password       = "fgwallet123456"
    static let hostName       = "smtp.yandex.com"
    static let subject        = "Contact Support"
}
*/

struct MSG {
    static let memoRequired             = "Memo is required!"
    static let recipientRequired        = "Recipient is required!"
    static let occurred                 = "An error occurred"
    static let phoneNumberdRequired     = "Phone numbeer is required!"
    static let newPindRequired          = "New PIN is required!"
    static let rePindRequired            = "Re-enter PIN is required!"
    static let rePinnotMatch            = "Re-enter PIN not match!"
    static let noToken                  = "Authorization has been denied for this request.Please login again"
    static let addressCopied            = "Address Copied"
    static let sucsses                  = "Success"
    
}

struct FGColor {
    static let primary     = colorFrom("2f3942")
    static let primaryDark = colorFrom("20262d")
    static let accent      = colorFrom("009688")
    static let green       = colorFrom("7CFC00")
    static let red         = colorFrom("FF0000")
    static let gray        = colorFrom("ecf0f1")
}

//struct FGStoryboard {
//    static let main                 = UIStoryboard.init(name: "Main", bundle: nil)
//    static let mainVC               = FGStoryboard.main.instantiateViewController(withIdentifier: "MainVC") as! MainVC
//    static let newWalletVC          = FGStoryboard.main.instantiateViewController(withIdentifier: "NewWalletVC") as! NewWalletVC
//    static let setingVC             = FGStoryboard.main.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
//    static let menuLeft             = FGStoryboard.main.instantiateViewController(withIdentifier: "MenuLeft") as! MenuLeft
//    static let restoreWalletVC      = FGStoryboard.main.instantiateViewController(withIdentifier: "RestoreWallet") as! RestoreWallet
//    static let recoveryPharseVC      = FGStoryboard.main.instantiateViewController(withIdentifier: "RecoveryPharseVC") as! RecoveryPharseVC
//    
//     static let loginVC      = FGStoryboard.main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//     static let homeVC      = FGStoryboard.main.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//    
//    static let submitOTP      = FGStoryboard.main.instantiateViewController(withIdentifier: "SubmitOTPVC") as! SubmitOTPVC
//    static let questionVC      = FGStoryboard.main.instantiateViewController(withIdentifier: "QuestionRecoveryVC") as! QuestionRecoveryVC
//    static let popupLanguageVC      = FGStoryboard.main.instantiateViewController(withIdentifier: "PopupLanguageVC") as! PopupLanguageVC
//     static let showRecoveryInfo      = FGStoryboard.main.instantiateViewController(withIdentifier: "ShowRecoveryPhaseVC") as! ShowRecoveryPhaseVC
//}

struct FG_Url {
    static let root                 = "https://smsapi.atmconsole.com"
    static let create               = "/api/notification/verify-code"
    static let verification         = "/api/notification/send-code"
    
    static let login                = "/api/user/login"
    static let change_pin           = "/api/user/change_pin"
    static let enable_premium_news  = "/api/user/enable_premium_news"
    static let balance              = "/api/wallet/balance"
    static let new_address          = "/api/wallet/new_address"
    static let last_address         = "/api/wallet/last_address"
    static let history              = "/api/wallet/history"
    static let spend                = "/api/wallet/spend"
    static let calculate_fee        = "/api/wallet/calculate-fee"
    static let converMoney          = "https://api.coindesk.com/v1/bpi/currentprice/JPY.json"
    static let getChart             = "https://www.quandl.com/api/v3/datasets/BCHARTS/ZAIFJPY.json?api_key=SHty8AwZ5qSiJPBC4E8j&start_date="

    
    static let blockcypher          = "https://live.blockcypher.com/btc/address/"
    
    static func getRequest(_ request: String) -> URL {
        
        let url =  URL(string: "\(FG_Url.root)\(request)")!
        
        return url
    }
}

