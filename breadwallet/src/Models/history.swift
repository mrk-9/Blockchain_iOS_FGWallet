//
//  history.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

//enum TypeTranslate: String {
//    case sent = "Send"
//    case received = "Received"
//
//    static func initWidth(_ str: String) {
//        if (str.lowercased() == "send") {
//            return
//        }
//    }
//}

struct History {
    var addresses = ""
    var amount    = ""
    var id: Int   = -1
    var memo      = ""
    var time      = ""
    var transaction_id = ""
    var type      = ""
    var userId: Int = -1
    
    init?(_ json: JSON) {
        
        guard let id = json["id"].int else {
            return  nil
        }
        self.id = id
        if let addresses = json["addresses"].string {
            self.addresses = addresses
        }
        
        if let amount = json["amount"].double {
            self.amount = String(amount)
        }
        
        if let memo = json["memo"].string {
            self.memo = memo
        }
        
        if let time = json["time"].string {
            self.time = time
        }
        
        if let transactioni_id = json["transaction_id"].string {
            self.transaction_id = transactioni_id
        }
        
        if let type = json["type"].string {
            self.type = type
        }
        if let user_id = json["user_id"].int {
            self.userId = user_id
        }

        
        
    }
}
