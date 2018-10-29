//
//  HomeVC.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {
    
    @IBOutlet weak var viewBlacen: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblAdress: UILabel!
    
    @IBOutlet weak var lblCurenblank: UILabel!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imageQR: UIImageView!
    
    @IBOutlet weak var btnReceive: UIButton!
    
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var imgCopy: UIImageView!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var lblConvert: UILabel!
   
    var rate: Double = 0
    var totalAmount: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
    
    func setupUI() {
        setupNavi()
        view.backgroundColor = FGColor.primary
        viewBlacen.boder()
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "wallet_ic_title"))
        btnSend.boder()
        imgCamera.image = #imageLiteral(resourceName: "icamera").withRenderingMode(.alwaysTemplate)
        imgCamera.tintColor = .white
        imgCopy.image = #imageLiteral(resourceName: "iccopy").withRenderingMode(.alwaysTemplate)
        imgCopy.tintColor = .white
        btnSend.setTitle(Klang.send.localized(), for: .normal)
        btnReceive.setTitle(Klang.receive.localized(), for: .normal)
        lblCurenblank.text = Klang.current_balance.localized()
        
    
        
        btnReceive.boder()
        btnCamera.boder()
          getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
    }
    
    func getData() {
      
        /*
        guard FGuserDefault.getToken().count > 0 else {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: mainVC), animated: true)
            return
        }
        */
        
        
        
        
        showLoading()
        
     //   let balance = globalAPI?.getBalance()
     //   let addr = globalAPI?.getAddr()
        
    //    var toaltal = 0.00000000
    //    toaltal = Double(balance!) / 100000000
   //     self.totalAmount =   Double(balance!) / 100000000
        
        //=====
        
        
        API.getConvertMoney({ (value) in
            hideLoading()
            var toaltal = 0.00000000
            
            let balance = globalAPI?.getBalance()
            let addr = globalAPI?.getAddr()
             toaltal = Double(balance!) / 100000000
           
            
            self.totalAmount = toaltal
            self.lblTotalAmount.text = "\(toaltal.formatBTC()) BTC"
            self.lblAdress.text = addr
            self.imageQR.image = (addr ?? "").generateQRCode()
            if let value = value {
                self.rate = value
                
                
                self.lblConvert.text = "￥ \((toaltal * value).formatJPY())"
            }else{
                self.lblConvert.text = "￥"
                self.rate = 0
            }
            
        })
    }
    //)
                
     //       })

     //   }
      
    
        
  //  }
    
    @IBAction func didTapCamera(_ sender: Any) {
        let scanVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanQRVC") as! ScanQRVC
        scanVC.getcode = { code in
            let sendVC = self.storyboard?.instantiateViewController(withIdentifier: "SendVC") as! SendVC
            sendVC.codeQR = code
            sendVC.rate = self.rate
            sendVC.totalAmount = self.totalAmount
            self.navigationController?.pushViewController(sendVC, animated: false)
        }
        present(UINavigationController.init(rootViewController: scanVC), animated: true, completion: nil)
    }
    
    
    
    @IBAction func didTapBtn_Send(_ sender: Any) {
        let sendVC = self.storyboard?.instantiateViewController(withIdentifier: "SendVC") as! SendVC
        sendVC.rate = self.rate
        sendVC.totalAmount = self.totalAmount
        navigationController?.pushViewController(sendVC, animated: true)
    }
    
    @IBAction func didTapBtn_Receive(_ sender: Any) {
        let reviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveVC") as! ReceiveVC
        if let address = lblAdress.text {
              reviceVC.address = address
        }
        
        if let image = imageQR.image {
            reviceVC.pictureQr = image
        }
        
        reviceVC.changeAddress = { [weak self] address, image in
            guard let strongSelf = self else {return}
                strongSelf.lblAdress.text = address
                strongSelf.imageQR.image = image ?? address.generateQRCode()
        }
      
     
        self.navigationController?.pushViewController(reviceVC, animated: true)
    }
    
    
    @IBAction func didTapRefesh(_ sender: Any) {
        getData()
    }
    
    @IBAction func didTapCopy(_ sender: Any) {
        if let text = lblAdress.text {
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = text
            self.showAlert(MSG.addressCopied)
        }
     
    }
    
}

extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
    }
    
}
