//
//  KeranjangCell.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 24/07/21.
//

import UIKit

class KeranjangCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productExpired: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var keranjangBackgroundView: UIView!
    @IBOutlet weak var stepperBackground: UIView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var totalProductLabel: UILabel!
    
    var totalProduk: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        keranjangBackgroundView.layer.cornerRadius = 20
        productImage.layer.cornerRadius = 10
        
        stepperBackground.cornerRadius(width: 7, height: 7)
        minusButton.cornerRadius(width: 3, height: 3)
        plusButton.cornerRadius(width: 3, height: 3)
    }

    @IBAction func plusPressed(_ sender: Any) {
        totalProduk += 1
        totalProductLabel.text = String(totalProduk)
    }
    
    @IBAction func minus(_ sender: UIButton) {
        if totalProduk > 0 {
            totalProduk -= 1
            totalProductLabel.text = String(totalProduk)
        }
    }
}
