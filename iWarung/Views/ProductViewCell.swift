//
//  ProductViewCell.swift
//  iWarung
//
//  Created by Miftahul Jihad on 26/07/21.
//

import UIKit

class ProductViewCell: UITableViewCell {
    
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var hargaLabel: UILabel!
    @IBOutlet weak var imageProduk: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
