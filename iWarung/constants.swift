//
//  constants.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 18/07/21.
//

import UIKit

struct K {
    static let appName = "iWarung"
    
    //MARK: - Blue Main Color
    let blueColor1Example = #colorLiteral(red: 0.03921568627, green: 0.4784313725, blue: 1, alpha: 1)
    static let blueColor1 = 0x0A7AFF
    
    //MARK: - Blue Color 2 Color
    let blueColor2Example = #colorLiteral(red: 0.02745098039, green: 0.4745098039, blue: 0.8470588235, alpha: 1)
    static let blueColor2 = 0x0779D8
    
    //MARK: - Blue Color 3 Color
    let blueColor3Example = #colorLiteral(red: 0.2549019608, green: 0.6392156863, blue: 1, alpha: 1)
    static let blueColor3 = 0x41A3FF
    
    //MARK: - Yellow Main Color
    let yellowColorExample = #colorLiteral(red: 1, green: 0.8392156863, blue: 0, alpha: 1)
    static let yellowColor = 0xFFD600
    
    //MARK: - Blue Gradient 1 Color
    let blueGradient1Example = #colorLiteral(red: 0, green: 0.5843137255, blue: 1, alpha: 1)
    static let blueGradient1 = 0x0095FF
    
    //MARK: - Blue Gradient 2 Color
    let blueGradient2Example = #colorLiteral(red: 0.02745098039, green: 0.4705882353, blue: 0.8431372549, alpha: 1)
    static let blueGradient2 = 0x0778D7
    
    //MARK: - Onboarding
    static let onboardingSlides: [Onboarding] = [
        Onboarding(image: #imageLiteral(resourceName: "produk 1x"), label: "Cepat", description: "Ketahui harga produk dan hitung penjualan  dengan cepat"),
        Onboarding(image: #imageLiteral(resourceName: "produk 1x"), label: "Mudah", description: "Kelola produk jualan anda dengan mudah"),
        Onboarding(image: #imageLiteral(resourceName: "meningkat"), label: "Meningkat", description: "Kualitas manajemen warung anda akan semakin meningkat")
    ]
    
    //MARK: - Notification Name
    static let NSpopUpDismissed = "PopUpDismissed"
}
