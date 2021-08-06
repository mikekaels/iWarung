//
//  UIButton.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 24/07/21.
//

import UIKit

extension UIButton{
    func createSegmentedControlButton(setTitle to: String)-> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(to, for: .normal)
        button.setTitleColor(K.greyLight, for: .normal)
        button.titleLabel?.font = K.segmentedButton
        
        let buttonTitleSize = (to as NSString).size(withAttributes: [NSAttributedString.Key.font : K.segmentedButton])
        print(to,": ",buttonTitleSize.width)
        
        button.widthAnchor.constraint(equalToConstant: CGFloat(buttonTitleSize.width + 20)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(buttonTitleSize.height)).isActive = true
        
        return button
    }
}
