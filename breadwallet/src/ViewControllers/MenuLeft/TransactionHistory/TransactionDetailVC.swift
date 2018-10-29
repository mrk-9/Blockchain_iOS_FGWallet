//
//  TransactionDetailVC.swift
//  FGWallet
//
//  Created by Ivan on 1/10/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import SafariServices
class TransactionDetailVC: BaseViewController {
    
    
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblMemo: UILabel!
    
    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblForm: UILabel!
    @IBOutlet weak var btnBlockChan: UIButton!
    
    @IBOutlet weak var lblTitleMemo: UILabel!
    
    @IBOutlet weak var lblTitleTo: UILabel!
    
    @IBOutlet weak var lblTitleForm: UILabel!
    
    @IBOutlet weak var lblTitleDate: UILabel!
    
    var history: History?
    let myAddress = "My Bitcoin Wallet"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        btnBlockChan.boder()
        setData()
        self.title =  Klang.transaction.localized()
        btnBlockChan.setTitle(Klang.verify_blockchain.localized(), for: .normal)
        lblTitleTo.text = Klang.to.localized()
        lblTitleForm.text = Klang.from.localized()
        lblTitleDate.text = Klang.date.localized()
        lblTitleMemo.text = Klang.memo.localized()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    @IBAction func didTapBtnBlockChan(_ sender: Any) {
        guard let history = history else {
            showAlert(MSG.occurred)
            return
        }
        let svc = SFSafariViewController.init(url: URL.init(string: FG_Url.blockcypher + history.addresses)!)
        svc.modalPresentationStyle = .overFullScreen
        svc.delegate = self
        UIApplication.shared.statusBarStyle = .lightContent
        present(svc, animated: true, completion: nil)
        
        
    }
    
    func setData() {
        guard let history = history else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if history.type.lowercased() == "sent" {
            lblType.text = Klang.send.localized()
            lblAmount.text = history.amount + "BTC"
            lblType.textColor = FGColor.red
            lblAmount.textColor = FGColor.red
             lblForm.text = myAddress
            lblTo.text = history.addresses
        }
        
        if history.type.lowercased() == "received" {
            lblType.text = Klang.received.localized()
            lblAmount.text = history.amount + "BTC"
            lblType.textColor = FGColor.green
            lblAmount.textColor = FGColor.green
            lblForm.text = history.addresses
            lblTo.text = myAddress
        }
        lblMemo.text = history.memo
        if history.memo.count == 0 {
            lblMemo.text = "No memo"
        }
        lblDate.text = history.time
        
    
        
        
    }
    

}
extension TransactionDetailVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
