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
    @IBOutlet weak var changeLabel: UILabel!
    
    var totalPemabayaran: Float = 0.0
    var totalChangeAmount: Float = 0.0
    var keranjang = [ItemKeranjang]()
    
    var currentString = ""
    
    @IBAction func finishTransactionPressed(_ sender: UIButton) {
        showModal()
    }
    
    func onButtonTapped() {
        self.performSegue(withIdentifier: "backToMainController", sender: self)
    }
}

//MARK: - View Did Load
extension PembayaranViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pembayaran"
        self.hideKeyboardWhenTappedAround()
        totalTagihan.text = String(totalPemabayaran).currencyFormatting()
        self.receivedMoneyTextfield.addTarget(self, action: #selector(PembayaranViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        configureTotalTagihanView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let money = Float(textField.text!) else {
            return
        }
        
        totalChangeAmount =  money - totalPemabayaran
        updateChangeAmount()
    }
    
    func updateChangeAmount() {
        self.changeLabel.text = "Rp \(String(totalChangeAmount).currencyFormatting())"
    }
}

extension PembayaranViewController: TransaksiSelesaiDelegate {
    
    
    
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
        self.changeLabel.text = nil
        self.totalChangeAmount = 0
    }
    
    @objc func showModal() {
        let slideVC = TransaksiSelesaiPasView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.delegate = self
        self.present(slideVC, animated: true, completion: { () in
            print("Modal openedd")
        })
    }
    
    func backToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func openRecipt() {
        let vc = UIStoryboard.init(name: "Recipt", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReciptViewController") as? ReciptViewController
        vc?.keranjang = keranjang
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

//MARK: - PresentationModal
extension PembayaranViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension PembayaranViewController {
    func configureTotalTagihanView() {
        totalTagihanBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        let TextSize = String(totalPemabayaran).currencyFormatting().SizeOf_String(font: UIFont.systemFont(ofSize: 34.0))
        print("Total Tagihan",TextSize)
//        totalTagihanBackgroundView.widthAnchor.constraint(equalToConstant: TextSize.width + 20).isActive = true
        totalTagihanBackgroundView.frame = CGRect(x: 0, y: 0, width: TextSize.width + 100, height: totalTagihanBackgroundView.frame.height)
//        button.widthAnchor.constraint(equalToConstant: CGFloat(buttonTitleSize.width + 20)).isActive = true
        
    }
}
