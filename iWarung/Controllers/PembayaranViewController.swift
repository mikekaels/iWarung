//
//  PembayaranViewController.swift
//  iWarung
//
//  Created by juli anggraini on 22/07/21.
//

import UIKit

class PembayaranViewController: UIViewController {
    
    @IBOutlet weak var totalTagihanBackgroundView: UIView!
    @IBOutlet weak var totalTagihan: UILabel!
    @IBOutlet weak var finishTransactionButton: UIButton!
    @IBOutlet weak var receivedMoneyTextfield: UITextField!
    
}

//MARK: - View Did Load
extension PembayaranViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pembayaran"
        
        
        
        // hide keyboard when tapping around
        self.hideKeyboardWhenTappedAround()
    }
}

extension PembayaranViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - Total tagihan background
        totalTagihanBackgroundView.cornerRadius(width: 7, height: 7)
        totalTagihanBackgroundView.addGradient()
        
        //MARK: - Finish transaction button
        finishTransactionButton.setTitle("Selesaikan Transaksi", for: .normal)
        finishTransactionButton.addGradient()
        finishTransactionButton.cornerRadius()
        
        //MARK: - Received Money Textfield
        receivedMoneyTextfield.keyboardType = UIKeyboardType.numberPad
        receivedMoneyTextfield.addBottomBorder()
        
        //MARK: - Button inside textfield
        var textFieldBtn: UIButton {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(receivedMoneyTextfield.frame.size.width - 40), y: CGFloat(5), width: CGFloat(40), height: CGFloat(30))
//            button.backgroundColor = UIColor
            button.addTarget(self, action: #selector(self.texfieldButton), for: .touchUpInside)
            return button
        }
        
        receivedMoneyTextfield.rightView = textFieldBtn
        receivedMoneyTextfield.rightViewMode = .always
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isHiddenHairline = false
    }
    
    @objc func texfieldButton() {
        self.receivedMoneyTextfield.text = nil
    }
    
    
}
