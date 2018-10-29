//
//  BaseViewController.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let viewline = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = FGColor.primary
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func setupNavi() {
        navigationController?.navigationBar.barTintColor = FGColor.primary
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        if let revealController = revealViewController() {
            navigationController?.navigationBar.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealViewController(), action: #selector(revealViewController().revealToggle(_:)))
        }
       
       
        
    }
    
   
    
    func addBackButton() {
        let backButon = UIBarButtonItem.init(image: #imageLiteral(resourceName: "backmenu"), style: .plain, target: self, action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = backButon
        
    }
    
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
        
      //  navigationController?.popToRootViewController(animated: true)
    }
}
