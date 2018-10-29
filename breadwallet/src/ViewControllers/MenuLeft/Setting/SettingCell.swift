//
//  SettingCell.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

protocol SettingCellDelegate: class {
    func settingCellSelectAbout()
    func settingCellSelectRecoveryPhase()
    func settingCellSelectChangePassword()
    func settingCellSelectRescanBLockChan()
    func settingCellSelectChangeLanguage()
}
class SettingCell: UITableViewCell {
    
    @IBOutlet weak var lblAbout: UILabel!
    
    @IBOutlet weak var lblRecovery: UILabel!
    
    @IBOutlet weak var lblChangePass: UILabel!
    
    @IBOutlet weak var lblRescanBlock: UILabel!
    
    @IBOutlet weak var viewsection: UIView!
    
    
    @IBOutlet weak var lblChangLanguage: UILabel!
    
    @IBOutlet weak var viewSection1: UIView!
    weak var delegate: SettingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewsection.boder()
        viewSection1.boder()
        settext()
        
    }
    
    func settext() {
        lblAbout.text = Klang.about.localized()
        lblRecovery.text = Klang.recovery_phrase.localized()
        lblChangePass.text = Klang.change_password.localized()
        lblRescanBlock.text = Klang.rescan_blockchain.localized()
        lblChangLanguage.text = Klang.change_language.localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func didTapAbout(_ sender: Any) {
        delegate?.settingCellSelectAbout()
    }
    
    @IBAction func didTapRecoveryPhase(_ sender: Any) {
        delegate?.settingCellSelectRecoveryPhase()
    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
        delegate?.settingCellSelectChangePassword()
    }
    
    @IBAction func didTapRescanBLockChang(_ sender: Any) {
        delegate?.settingCellSelectRescanBLockChan()
    }
    
    @IBAction func didTapChangeLanguage(_ sender: Any) {
        delegate?.settingCellSelectChangeLanguage()
    }
    
}
