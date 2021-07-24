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
        byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
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
