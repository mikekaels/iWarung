//
//  ProductItemViewCell.swift
//  iWarung
//
//  Created by Miftahul Jihad on 28/07/21.
//

import UIKit

class ProductItemViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productExpired: UILabel!
    @IBOutlet weak var productStock: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productImage.layer.cornerRadius = 10
    }

}
