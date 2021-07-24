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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        keranjangBackgroundView.layer.cornerRadius = 20
//        keranjangBackgroundView.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        productImage.layer.cornerRadius = 10
    }

}
