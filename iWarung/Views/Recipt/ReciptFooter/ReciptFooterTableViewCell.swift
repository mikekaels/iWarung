//
//  ReciptFooterTableViewCell.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 10/08/21.
//

import UIKit

class ReciptFooterTableViewCell: UITableViewCell {
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var totalBelanjaLabel: UILabel!
    @IBOutlet weak var uangLabel: UILabel!
    @IBOutlet weak var kembalianLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topLine.addDashedLineBorder(color: UIColor(rgb: K.blueColor1))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(totalBelanja: Float, uang: Float, kembalian: Float) {
        self.totalBelanjaLabel.text = "Rp \(String(totalBelanja).currencyFormatting())"
        self.uangLabel.text = "Rp \(String(uang).currencyFormatting())"
        self.kembalianLabel.text = "Rp \(String(kembalian).currencyFormatting())"
    }
    
}
