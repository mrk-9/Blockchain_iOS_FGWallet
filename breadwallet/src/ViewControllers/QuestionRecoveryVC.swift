//
//  QuestionRecoveryVC.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

extension Array
{
    func random() -> Element
    {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}


class QuestionRecoveryVC: UIViewController {
    var shuffled: [(String, Int)] = []
    var index = 0
    var questionFirst = true
   
    @IBOutlet weak var lblQuestions: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
          setup()
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
    func setup() {
        self.view.isUserInteractionEnabled = true
        
        var recoveryPhase = FGuserDefault.getRecoveryPhase().split(separator: " ")
        var recovery = FGuserDefault.getRecoveryPhase().split(separator: " ")
        
         let str = globalAPI!.getPhrase().split(separator: " ")
        
        recoveryPhase = str
        recovery = str
      
        
        
        for i in 1...6 {
            let rand = Int(arc4random_uniform(UInt32(recovery.count)))
            let text = String(recovery[rand])
            let button = view.viewWithTag(i) as! UIButton
            button.setTitle(text, for: .normal)
            shuffled.append((text, recoveryPhase.index(of: recovery[rand])!))
            
            recovery.remove(at: rand)
            button.addTarget(self, action: #selector(selectAnser(_ :)), for: .touchUpInside)
            button.setTitleColor(FGColor.accent, for: .normal)
            
        }
        
        print(shuffled)
        
        index = Int(arc4random_uniform(UInt32(6)))
         print("------ \(index)")
       
//        lblQuestions.text = "Select the \(shuffled[index].1 + 1)th word of your recovery phrase from the list below"
        lblQuestions.text = Klang.msg_recoveryFirst.localized() + "\(shuffled[index].1 + 1)" + Klang.msg_recoveryLast.localized()
        
        
    }
    
   @objc func selectAnser(_ sender : UIButton) {
        self.view.isUserInteractionEnabled = false
        let button = view.viewWithTag(sender.tag) as! UIButton
        print(shuffled[index])
        print(index)
    print(sender.tag)
    
        if sender.tag - 1  == index{
    

        button.setTitleColor(FGColor.green, for: .normal)
            
        if questionFirst == true {
            let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionRecoveryVC") as! QuestionRecoveryVC
            questionVC.questionFirst = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.revealViewController().pushFrontViewController(questionVC, animated: true)
            })
            
         
         
            
        }
        else {
            
           
             UserDefaults.standard.set(true, forKey: FGuserDefault.is_InputRecoveryPhase)
           
            
            UserDefaults.standard.synchronize()
            
            
            let homeVC =  self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                showLoading()
        self.revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: homeVC), animated: true)
            })
           
        }
            
      
            
        
        }else {
            button.setTitleColor(FGColor.red, for: .normal)
            let showRecoveryPhase = self.storyboard?.instantiateViewController(withIdentifier: "ShowRecoveryPhaseVC") as! ShowRecoveryPhaseVC
            showRecoveryPhase.isFirstQuesttion = questionFirst
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                 self.revealViewController().pushFrontViewController(showRecoveryPhase, animated: true)
            })
            
         

          
    }
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupNavi()
//        addBackButton()
//        revealViewController().panGestureRecognizer().isEnabled = false
      
    }
    
 
    
    
    
}
