//
//  KeranjangViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 23/07/21.
//

import UIKit

protocol KeranjangDelegate {
    func didTapPlusOrMinusButton(indexPath: Int, totalProduct: Int)
    func deleteProduct(indexPath: Int)
}

class KeranjangViewController: UIViewController {
    @IBOutlet weak var keranjangCollectionView: UICollectionView!
    @IBOutlet weak var totalBackgroundViewController: UIView!
    @IBOutlet weak var pembayaranButton: UIButton!
    @IBOutlet weak var pembayaranArrowButton: UIButton!
    @IBOutlet weak var totalBelanja: UILabel!
    
    let productService : Persisten = Persisten()
    var delegate: KeranjangDelegate!
    
    var keranjang = [ItemKeranjang]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Keranjang"
        let nibCell = UINib(nibName: "KeranjangCell", bundle: nil)
        keranjangCollectionView.register(nibCell, forCellWithReuseIdentifier: "keranjangCell")
        
        keranjangCollectionView.dataSource = self
        keranjangCollectionView.delegate = self
        updateKeranjang()
        //        totalBelanja.text = String(totalSum)
    }
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            UIColor.purple.cgColor,
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor,
            UIColor.red.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
        gradient.endPoint = CGPoint(x: 1, y: endY)
        return gradient
    }()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPembayaran") {
            
            let landingVC = segue.destination as! PembayaranViewController
            landingVC.totalPemabayaran = K.totalPrice(keranjang: keranjang)
            landingVC.keranjang = keranjang
        }
    }
    
    func dismissView() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Large title, Back Button, Navigation Bar
extension KeranjangViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //        //MARK: - Change back button title to Kembali
        //        navigationController?.navigationBar.backItem?.title = "kembali"
        
        //MARK: - No Border on Navigation bar
        navigationController?.isHiddenHairline = true
        
        //MARK: - Background Total
        totalBackgroundViewController.cornerRadius(width: 7, height: 7)
        totalBackgroundViewController.addGradient()
        
        //MARK: - Pembayaran Button
        pembayaranButton.cornerRadius()
        pembayaranButton.addGradient()
        
        //MARK: - Pembayaran Arrow Button
        pembayaranArrowButton.backgroundColor = UIColor(rgb: K.blueColor3)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .small)
        
        let BoldDoc = UIImage(systemName: "arrow.right", withConfiguration: config)
        
        pembayaranArrowButton.setImage(BoldDoc, for: .normal)
        pembayaranArrowButton.tintColor = .white
        pembayaranArrowButton.cornerRadius(width: 4, height: 4)
        configureArrowAnimation()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isHiddenHairline = false
    }
    
    func configureArrowAnimation() {
        if let frame = pembayaranArrowButton.superview?.convert(pembayaranArrowButton.frame, to: nil) {
            UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [.autoreverse, .repeat,], animations: {
                self.pembayaranArrowButton.frame = CGRect(x: 264.0, y: 19.0, width: 24.0, height: 24.0)
            }, completion: nil)
        }
    }
    
}

extension KeranjangViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keranjang.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = keranjangCollectionView.dequeueReusableCell(withReuseIdentifier: "keranjangCell", for: indexPath) as! KeranjangCell
        
        cell.delegate = self
        
        cell.totalProduk = keranjang[indexPath.row].qty
        cell.totalProductLabel.text = String(keranjang[indexPath.row].qty)
        cell.productImage.image = UIImage(data: keranjang[indexPath.row].image)
        cell.productName.text = keranjang[indexPath.row].name
        cell.productExpired.text = K.formattedDate(date: keranjang[indexPath.row].expired)
        cell.productPrice.text = String(keranjang[indexPath.row].price).currencyFormatting()
        cell.indexPath = indexPath.row
        
        // giving shadow to the cell
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = #colorLiteral(red: 0.3294117647, green: 0.4039215686, blue: 0.6039215686, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 0, height: 35)
        cell.layer.shadowRadius = 75
        cell.layer.shadowOpacity = 0.15
        cell.layer.masksToBounds = false //<-
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension KeranjangViewController: KeranjangCellDelegate {
    func didTapPlusOrMinusButton(indexPath: Int, totalProduct: Int) {
        keranjang[indexPath].qty = totalProduct
        self.keranjangCollectionView.reloadData()
        delegate.didTapPlusOrMinusButton(indexPath: indexPath, totalProduct: totalProduct)
        updateKeranjang()
    }
    
    func deleteProduct(indexPath: Int) {
        keranjang.remove(at: indexPath)
        self.keranjangCollectionView.reloadData()
        delegate.deleteProduct(indexPath: indexPath)
        updateKeranjang()
        
        if keranjang.count == 0 {
            dismissView()
        }
    }
    
    func updateKeranjang() {
        self.totalBelanja.text = String(K.totalPrice(keranjang: keranjang)).currencyFormatting()
    }
}
