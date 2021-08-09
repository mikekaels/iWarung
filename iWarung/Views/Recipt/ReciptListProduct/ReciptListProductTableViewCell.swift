//
//  ReciptListProductTableViewCell.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 10/08/21.
//

import UIKit

class ReciptListProductTableViewCell: UITableViewCell {
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(qty: Int, productName: String, totalPrice: Float) {
        self.qty.text = String(qty)
        self.productName.text = productName
        self.totalPrice.text = "Rp \(String(totalPrice).currencyFormatting())"
    }
}
