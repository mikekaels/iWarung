//
//  UIView.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 24/07/21.
//

import UIKit

extension UIView {
    
    func cornerRadius(width: Int = 11, height: Int = 11){
        //
        let maskPath1 = UIBezierPath(roundedRect: bounds,
        byRoundingCorners: [.allCorners],
        cornerRadii: CGSize(width: width, height: height))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func addGradient(
        colors: [UIColor] = [.init(rgb: 0x0095FF), .init(rgb: 0x0778D7)]
    ){
            
        let gradient = CAGradientLayer()
            
        gradient.frame.size = self.frame.size
        gradient.frame.origin = CGPoint(x: 0.0, y: 0.0)

        gradient.colors = colors.map{ $0.cgColor }
        
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        self.layer.insertSublayer(gradient, at: 0)
        }
    
    @discardableResult
        func applyGradient(colours: [UIColor]) -> CAGradientLayer {
            return self.applyGradient(colours: colours, locations: nil)
        }
    
    @discardableResult
        func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            self.layer.insertSublayer(gradient, at: 0)
            return gradient
        }
}

extension UIView {
    func addDashedBorder(_ color: UIColor = UIColor(rgb: K.blueColor1), withWidth width: CGFloat = 2, cornerRadius: CGFloat = 5, dashPattern: [NSNumber] = [3,6]) {

    let shapeLayer = CAShapeLayer()

    shapeLayer.bounds = bounds
    shapeLayer.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
    shapeLayer.fillColor = nil
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = width
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round // Updated in swift 4.2
    shapeLayer.lineDashPattern = dashPattern
    shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath

    self.layer.addSublayer(shapeLayer)
  }
}
