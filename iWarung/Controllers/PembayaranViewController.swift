//
//  PembayaranViewController.swift
//  iWarung
//
//  Created by juli anggraini on 22/07/21.
//

import UIKit

class PembayaranViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var totalTagihanBackgroundView: UIView!
    @IBOutlet weak var totalTagihan: UILabel!
    @IBOutlet weak var finishTransactionButton: UIButton!
    @IBOutlet weak var receivedMoneyTextfield: UITextField!
    @IBOutlet weak var changeLabel: UILabel!
    
    var totalPembayaran: Float = 0.0
    var totalChangeAmount: Float = 0.0
    var money: Float = 0.0
    var keranjang = [ItemKeranjang]()
    
    var currentString = ""
    
    @IBAction func finishTransactionPressed(_ sender: UIButton) {
        if Double(receivedMoneyTextfield.text ?? "") ?? 0 <= 0 ||  totalChangeAmount < 0{
            showAlert(withTitle: "Uang belum cukup", message: "Silahkan isi uang diterima dengan benar")
        } else {
            showModal()
        }
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
        totalTagihan.text = String(totalPembayaran).currencyFormatting()
        receivedMoneyTextfield.delegate = self
        self.receivedMoneyTextfield.addTarget(self, action: #selector(PembayaranViewController.textFieldDidChange(_:)), for: .editingChanged)
        self.receivedMoneyTextfield.addTarget(self, action: #selector(textDidChange), for: UIControl.Event.editingDidEnd)
        
        configureTotalTagihanView()
    }
    
    @objc func textDidChange(_ textField:UITextField) {
        if textField.text?.count == 0 {
            totalChangeAmount = 0
            updateChangeAmount()
        }
     }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent "0" characters as the first characters. (i.e.: There should not be values like "003" "01" "000012" etc.)
        if textField.text?.count == 0 && string == "0" {
            totalChangeAmount = 0
            return false
        }
        
        //Only allow numbers. No Copy-Paste text values.
        let allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789.")
        let textCharacterSet = CharacterSet.init(charactersIn: textField.text! + string)
        if !allowedCharacterSet.isSuperset(of: textCharacterSet) {
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let money = Float(textField.text!) else {
            return
        }
        self.money = money
        totalChangeAmount =  self.money - totalPembayaran
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
        
        configureTotalTagihanView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTotalTagihanView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isHiddenHairline = false
        
        configureTotalTagihanView()
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
        let vc = UIStoryboard.init(name: "Recipt", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReciptViewController") as! ReciptViewController
        vc.keranjang = keranjang
        vc.uang = money
        vc.kembalian = totalChangeAmount
        self.navigationController?.pushViewController(vc, animated: true)
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
        let TextSize = String(totalPembayaran).currencyFormatting().SizeOf_String(font: UIFont.systemFont(ofSize: 34.0))
//        totalTagihanBackgroundView.widthAnchor.constraint(equalToConstant: TextSize.width + 20).isActive = true
        totalTagihanBackgroundView.frame = CGRect(x: 0, y: 0, width: TextSize.width + 100, height: totalTagihanBackgroundView.frame.height)
//        button.widthAnchor.constraint(equalToConstant: CGFloat(buttonTitleSize.width + 20)).isActive = true
        
    }
}
