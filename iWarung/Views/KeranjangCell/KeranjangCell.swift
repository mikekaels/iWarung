//
//  KeranjangCell.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 24/07/21.
//

import UIKit

protocol KeranjangCellDelegate {
    func didTapPlusOrMinusButton(indexPath: Int,totalProduct: Int, cPoint: CGRect)
    func deleteProduct(indexPath: Int)
}

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
    
    var totalProduk: Int = 1
    var indexPath: Int = 0
    var keranjangVC = KeranjangViewController()
    
    var delegate: KeranjangCellDelegate!
    
    var cPoint : CGRect = CGRect(x: 0.0, y: 0.0, width: 0, height: 0)
    
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
        delegate.didTapPlusOrMinusButton(indexPath: self.indexPath, totalProduct: self.totalProduk, cPoint: self.cPoint)
        totalProductLabel.text = String(totalProduk)
    }
    
    @IBAction func minus(_ sender: UIButton) {
        if totalProduk > 1 {
            totalProduk -= 1
            delegate.didTapPlusOrMinusButton(indexPath: self.indexPath, totalProduct: self.totalProduk, cPoint: self.cPoint)
            totalProductLabel.text = String(totalProduk)
        } else {
            self.removeCellAnimation()
        }
    }
}
extension KeranjangCell {
    func removeCellAnimation() {
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: .beginFromCurrentState, animations: {
            self.rotate(angle: 5)
            self.center = CGPoint(x: self.center.x + 10.0, y: self.center.y + 5)
        }, completion: nil)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.6, options: .beginFromCurrentState, animations: {
            self.rotate(angle: -30)
            self.center = CGPoint(x: self.center.x - 400, y: self.center.y)
        }, completion: {_ in
            self.delegate.deleteProduct(indexPath: self.indexPath)
        })
    }
}
