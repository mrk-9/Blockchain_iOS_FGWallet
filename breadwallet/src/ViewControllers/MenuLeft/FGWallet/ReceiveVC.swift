//
//  ReceiveVC.swift
//  FGWallet
//
//  Created by Ivan on 1/9/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class ReceiveVC: BaseViewController {

    @IBOutlet weak var btnCreatAddress: UIButton!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var imgQr: UIImageView!
    @IBOutlet weak var imgCopy: UIImageView!

    var changeAddress: ((String, UIImage?) ->())?
    var pictureQr = UIImage()
    var address = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        addBackButton()
        navigationItem.title = Klang.receive.localized()
        btnCreatAddress.setTitle(Klang.create_new_address.localized(), for: .normal)
        imgCopy.image = #imageLiteral(resourceName: "iccopy").withRenderingMode(.alwaysTemplate)
        imgCopy.tintColor = .white
        self.imgQr.image = pictureQr
        self.lblAdress.text = address
        btnCreatAddress.boder()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    @IBAction func didTapbtnCopy(_ sender: Any) {
        if let text = lblAdress.text {
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = text
            self.showAlert(MSG.addressCopied)
        }
    }
    
    @IBAction func didTapBtnCreatNewAddress(_ sender: Any) {
        showLoading()
        API.creatNewAddress { [weak self] (address, error) in
            hideLoading()
            guard let strongSelf = self else {return}
            if error == nil {
                strongSelf.lblAdress.text = address
                strongSelf.imgQr.image = (address ?? "").generateQRCode()
                strongSelf.changeAddress?(address ?? "", strongSelf.imgQr.image)
                strongSelf.showAlert(MSG.sucsses)
    
                
            }else{
                strongSelf.showAlert(error!.msg ?? MSG.occurred)
            }
        }
    }
    
}
