//
//  SettingVC.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

fileprivate let idCell = "SettingCell"

class SettingVC: BaseViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi()
        navigationItem.title = Klang.settings.localized()
        self.tableView.reloadData()
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! SettingCell
        cell.settext()
        cell.delegate = self
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

extension SettingVC: SettingCellDelegate {
    
    func settingCellSelectAbout() {
        let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        self.navigationController?.pushViewController(aboutVC, animated: true)
        
    }
    
    func settingCellSelectRecoveryPhase() {
        let importantVC = self.storyboard?.instantiateViewController(withIdentifier: "ImportantVC") as! ImportantVC
        self.navigationController?.pushViewController(importantVC, animated: true)
    }
    func settingCellSelectChangePassword() {
        let changePass = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(changePass, animated: true)
        
    }
    func settingCellSelectRescanBLockChan() {
        let waletVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: waletVC), animated: true)
        
    }
    func settingCellSelectChangeLanguage() {
        let changeLanguage = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLanguage") as! ChangeLanguage
        self.navigationController?.pushViewController(changeLanguage, animated: true)
        
    }
    
}
