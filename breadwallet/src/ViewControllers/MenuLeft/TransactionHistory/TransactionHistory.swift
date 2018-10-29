//
//  TransactionHistory.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

private let idCellSent = "TransactionSentCell"
private let idCellRece = "TransactionReceivedCell"

class TransactionHistory: BaseViewController {
    
   

    @IBOutlet weak var tableView: UITableView!
    let refeshControler = UIRefreshControl()
     var historys: [History] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNavi()
        navigationItem.title = Klang.transaction_history.localized()
       
        refeshControler.addTarget(self, action: #selector(loadData), for: .valueChanged)
         refeshControler.tintColor = .white
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refeshControler
        } else {
            self.tableView.backgroundView = refeshControler
        }
        self.tableView.contentOffset = CGPoint(x:0, y: -self.refeshControler.frame.size.height)
       
        loadData()
        self.tableView.tableFooterView = UIView()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func loadData() {
      
        self.refeshControler.beginRefreshing()
        API.getTransion {[weak self] (data, error) in
            guard let strongself = self else {
                return
            }
            guard error == nil else {
                strongself.refeshControler.perform(#selector(strongself.refeshControler.endRefreshing), with: nil, afterDelay: 0.2)
                return
            }
            
            strongself.historys = data
            DispatchQueue.main.async {
                strongself.tableView.reloadData()
                strongself.refeshControler.perform(#selector(strongself.refeshControler.endRefreshing), with: nil, afterDelay: 0.2)
            }
            
        
            
        }
        
    }
    

}

extension TransactionHistory: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
     
        let history = historys[indexPath.item]
        
        if history.type.lowercased() == "sent" {
             let cellSend = self.tableView.dequeueReusableCell(withIdentifier: idCellSent, for: indexPath) as! TransactionSentCell
            cellSend.lblTime.text = String(history.time.split(separator: " ")[0])
            cellSend.lblMemo.text = "-\(history.memo)"
            cellSend.lblAmount.text = history.amount + "BTC"
            cellSend.lblSend.text = Klang.send.localized()
            return cellSend
        }else{
               let cellRecevie = self.tableView.dequeueReusableCell(withIdentifier: idCellRece, for: indexPath) as! TransactionReceivedCell
            cellRecevie.lblTime.text = String(history.time.split(separator: " ")[0])
            cellRecevie.lblAmmout.text = history.amount + "BTC"
            cellRecevie.lblReviced.text = Klang.received.localized()
            return cellRecevie
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailVC") as! TransactionDetailVC
        detail.history = historys[indexPath.item]
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let history = historys[indexPath.item]
        
        if history.type.lowercased() == "sent" {
            return 60
        }
        return 44
        
    }
    
   
}
