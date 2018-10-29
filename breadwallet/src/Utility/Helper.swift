//
//  Helper.swift
//  FGWallet
//
//  Created by Ivan on 1/6/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

 func colorFrom(_ hexStr: String) -> UIColor {
    var cString:String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
    
}

func showLoading(_ msg: String? = nil) {
    guard let msg = msg, !msg.isEmpty else {
        RappleActivityIndicatorView.startAnimating()
        return
    }
    RappleActivityIndicatorView.startAnimatingWithLabel(msg)
    
    
}

func hideLoading() {
    RappleActivityIndicatorView.stopAnimation()
}

func degreesToRadians (_ value:CGFloat) -> CGFloat {
    return value * CGFloat.pi / 180.0
}

func radiansToDegrees (_ value:CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat.pi
}

func dialogBezierPathWithFrame(_ frame: CGRect, arrowOrientation orientation: UIImageOrientation, arrowLength: CGFloat = 20.0) -> UIBezierPath {
    // Translate frame to neutral coordinate system & transpose it to fit the orientation.
    var transposedFrame = CGRect.zero
    switch orientation {
    case .up, .down, .upMirrored, .downMirrored:
        transposedFrame = CGRect(x: 0, y: 0, width: frame.size.width - frame.origin.x, height: frame.size.height - frame.origin.y)
    case .left, .right, .leftMirrored, .rightMirrored:
        transposedFrame = CGRect(x: 0, y: 0,  width: frame.size.height - frame.origin.y, height: frame.size.width - frame.origin.x)
    }
    
    // We need 7 points for our Bezier path
    let midX = transposedFrame.midX
    let point1 = CGPoint(x: transposedFrame.minX, y: transposedFrame.minY + arrowLength)
    let point2 = CGPoint(x: midX - (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point3 = CGPoint(x: midX, y: transposedFrame.minY)
    let point4 = CGPoint(x: midX + (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point5 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.minY + arrowLength)
    let point6 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.maxY)
    let point7 = CGPoint(x: transposedFrame.minX, y: transposedFrame.maxY)
    
    // Build our Bezier path
    let path = UIBezierPath()
    path.move(to: point1)
    path.addLine(to: point2)
    path.addLine(to: point3)
    path.addLine(to: point4)
    path.addLine(to: point5)
    path.addLine(to: point6)
    path.addLine(to: point7)
    path.close()
    
    // Rotate our path to fit orientation
    switch orientation {
    case .up, .upMirrored:
    break // do nothing
    case .down, .downMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(180.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.width, y: transposedFrame.size.height))
    case .left, .leftMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(-90.0)))
        path.apply(CGAffineTransform(translationX: 0, y: transposedFrame.size.width))
    case .right, .rightMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(90.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.height, y: 0))
    }
    
    return path
}




