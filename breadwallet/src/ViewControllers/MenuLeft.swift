//
//  MenuLeft.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
fileprivate let idCell = "MenuLeftCell"
class MenuLeft: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let menus = ["FG Wallet",
                 Klang.transaction_history,
                 Klang.market_chart,
                 Klang.atm_map,
                 Klang.settings,
                 Klang.contact_support,
                 Klang.log_out]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        
    }
 
    /*
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        //Insert function to be run upon dismiss of VC2
    }
 */
 
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func logout() {
        let alert = UIAlertController(title: APPName, message: "Do you want to logout?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            FGuserDefault.removeAllValue()
            self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC), animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}



extension MenuLeft: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! MenuLeftCell
        cell.lblTitle.text = menus[indexPath.item].localized()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func gotoHOME()
    {
        
        if let reval = self.revealViewController() {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            reval.pushFrontViewController(UINavigationController.init(rootViewController: homeVC), animated: true)
        }
            
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
           gotoHOME()
        case 1:
            
         
 
 
let transitionDelegate: ModalTransitionDelegate

transitionDelegate = ModalTransitionDelegate(type: .transactionDetail, store: globalAPI!.store)


            let didSelectTransaction: ([Transaction], Int) -> Void = { transactions, selectedIndex in
                guard let kvStore = globalAPI?.walletManager.apiClient?.kv else { return }
                let transactionDetails = TransactionDetailsViewController(store: globalAPI!.store, transactions: transactions, selectedIndex: selectedIndex, kvStore: kvStore)
                transactionDetails.modalPresentationStyle = .overFullScreen
                transactionDetails.transitioningDelegate = transitionDelegate
                transactionDetails.modalPresentationCapturesStatusBarAppearance = true
                self.present(transactionDetails, animated: true, completion: nil)
            }
            
            
            
            var accountViewController: AccountViewController?
            
accountViewController = AccountViewController(sender: self, store: globalAPI!.store, didSelectTransaction: didSelectTransaction )
             
             accountViewController?.walletManager = globalAPI?.walletManager
             
            accountViewController?.sendCallback = { globalAPI!.store.perform(action: RootModalActions.Present(modal: .send)) }
            accountViewController?.receiveCallback = { globalAPI!.store.perform(action: RootModalActions.Present(modal: .receive)) }
            accountViewController?.menuCallback = { globalAPI!.store.perform(action: RootModalActions.Present(modal: .menu)) }
 

            revealViewController().pushFrontViewController(UINavigationController(rootViewController: accountViewController!),animated: true)
            
            
            
        case 2:
            let marketChar = self.storyboard?.instantiateViewController(withIdentifier: "MarketCharVC") as! MarketCharVC
            revealViewController().pushFrontViewController(UINavigationController(rootViewController: marketChar), animated: true)
        case 3:
            let atmMapVC = self.storyboard?.instantiateViewController(withIdentifier: "ATMMapVC") as! ATMMapVC
            revealViewController().pushFrontViewController(UINavigationController(rootViewController: atmMapVC), animated: true)
        case 4:
            let setingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            if let reval = self.revealViewController() {
                reval.pushFrontViewController(UINavigationController.init(rootViewController: setingVC), animated: true)
            }
        case 5:
            let contactSuportVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactSuportVC") as! ContactSuportVC
            revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: contactSuportVC), animated: true)
        case 6:
            logout()
        default:
            return
        }
    }
    
    
}
