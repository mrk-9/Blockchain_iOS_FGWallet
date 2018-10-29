//
//  ExtensionUIView.swift
//  FGWallet
//
//  Created by Ivan on 1/5/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
extension UIView {
    func boder(_ color: UIColor = .white, _ boderwidth: CGFloat = 1, _ radius: CGFloat = 0 ) {
        layer.cornerRadius = radius
        layer.borderWidth = boderwidth
        layer.borderColor = color.cgColor
        
    }
    
    func shake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        
        layer.add(animation, forKey: "shake")
    }
    
    func applyArrowDialogAppearanceWithOrientation(arrowOrientation: UIImageOrientation) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dialogBezierPathWithFrame(self.frame, arrowOrientation: arrowOrientation).cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = shapeLayer
    }
}
