//
//  AnnotationView.swift
//  FGWallet
//
//  Created by Ivan on 1/13/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import MapKit

class AnnotationView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var contenView: UIView!
    
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSub: UILabel!
    
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle.main
        let name =  "AnnotationView"
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
 
    
   
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        guard let nibView = loadViewFromNib() else {
            return
        }
        view = nibView
        addSubview(view)
        view.frame = self.bounds
        
    }
    
    
    
}
