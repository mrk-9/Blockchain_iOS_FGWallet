//
//  ShowRecoveryPhaseVC.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class ShowRecoveryPhaseVC: BaseViewController {
     
     var isFirstQuesttion = true
     
     @IBOutlet weak var lblRecovery: UILabel!
     
     @IBOutlet weak var lblMsgTitle: UILabel!
     
     @IBOutlet weak var lblPleaseWriteDown: UILabel!
     
     @IBOutlet weak var btnNext: UIButton!
     
     override func viewDidLoad() {
          super.viewDidLoad()
          lblMsgTitle.text = Klang.title_recovery_phrase2.localized()
          lblPleaseWriteDown.text = Klang.msg_recovery_phrase2.localized()
        //  lblRecovery.text = FGuserDefault.getRecoveryPhase()
        lblRecovery.text = globalAPI?.getPhrase();
            
            btnNext.setTitle(Klang.next.localized(), for: .normal)
          btnNext.boder()
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
     }
     
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          setupNavi()
          addBackButton()
          self.revealViewController().panGestureRecognizer().isEnabled = false
          
     }
     
     
     @IBAction func didTapBtnNext(_ sender: Any) {
          let question = self.storyboard?.instantiateViewController(withIdentifier: "QuestionRecoveryVC") as! QuestionRecoveryVC
          question.questionFirst = isFirstQuesttion
          revealViewController().pushFrontViewController(question, animated: true)
          
     }
     
     
     
     
}
