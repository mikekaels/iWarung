//
//  KeranjangPopUp.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 26/07/21.
//

import UIKit

@IBDesignable class KeranjangPopUp: UIView {
    
    @IBOutlet weak var jumlahProduk: UILabel!
    @IBOutlet weak var totalBelanjaan: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
 
    private func commonInit() {
        let bundle = Bundle.init(for: KeranjangPopUp.self)
         
        if let viewToAdd = bundle.loadNibNamed("KeranjangPopUp", owner: self, options: nil), let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

}
