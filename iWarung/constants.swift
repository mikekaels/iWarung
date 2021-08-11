//
//  constants.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 18/07/21.
//

import UIKit

struct K {
    static let appName = "iWarung"
    
    //MARK: - Picker
    static let pickerData = ["Barcode", "No-Barcode"]
    
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
    
    //MARK: - Grey Light Color
    let greyLightExample = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
    static let greyLight = UIColor(rgb: 0xD3D3D3)
    
    //MARK: - Onboarding
    static let onboardingSlides: [Onboarding] = [
        Onboarding(image: #imageLiteral(resourceName: "produk 1x"), label: "Cepat", description: "Ketahui harga produk dan hitung penjualan  dengan cepat"),
        Onboarding(image: #imageLiteral(resourceName: "produk 1x"), label: "Mudah", description: "Kelola produk jualan anda dengan mudah"),
        Onboarding(image: #imageLiteral(resourceName: "meningkat"), label: "Meningkat", description: "Kualitas manajemen warung anda akan semakin meningkat")
    ]
    
    //MARK: - Notification Name
    static let NSpopUpDismissed = "PopUpDismissed"
    
    //MARK: - Segmented Button
    
    static let segmentedButtonSize = CGFloat(16)
    static let segmentedButton = UIFont.systemFont(ofSize: segmentedButtonSize, weight: .medium)
    static let segmentedButtonSelected = UIFont.systemFont(ofSize: segmentedButtonSize, weight: .semibold)
    
    static let allProducts = UIButton().createSegmentedControlButton(setTitle: "Semua Produk")
    static let popular = UIButton().createSegmentedControlButton(setTitle: "Populer")
    static let expired = UIButton().createSegmentedControlButton(setTitle: "Kadaluwarsa")
    static let lastAdded = UIButton().createSegmentedControlButton(setTitle: "Terakhir ditambahkan")
    static let firstAdded = UIButton().createSegmentedControlButton(setTitle: "Pertama ditambahkan")
    
    //MARK: - NOTIFICATION NAME
    static let detectedNotificationKey = Notification.Name(rawValue: "detected")
    
    static let xPosition = 0.0
    static let yPosition = -0.5
    static let width = 251.0
    static let height = 34.0
    
    static func formattedDate(date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MM-yyyy"
        return formatter.string(from: date).uppercased()
    }
    
    static func totalPrice(keranjang: [ItemKeranjang]) -> Float  {
        var total: Float = 0.0
        
        for product in keranjang {
            total += (product.price * Float(product.qty))
        }
        
        return total
    }
    
    static func getOnlyDate()-> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "d-MM-yyyy"
        let dateString = df.string(from: date).uppercased()
        return dateString
    }
    
    static func getOnlyTime()-> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "hh:mm"
        df.timeStyle = .short
        let dateString = df.string(from: date).uppercased()
        return dateString
    }
}

