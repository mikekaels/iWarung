//
//  KeranjangViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 23/07/21.
//

import UIKit

class KeranjangViewController: UIViewController {
    @IBOutlet weak var keranjangCollectionView: UICollectionView!
    @IBOutlet weak var totalBackgroundViewController: UIView!
    @IBOutlet weak var pembayaranButton: UIButton!
    @IBOutlet weak var pembayaranArrowButton: UIButton!
    @IBOutlet weak var totalBelanja: UILabel!
    
    var products: [ProductItem] = []
    
    var totalSum = keranjangList.map({$0.total}).reduce(0, +)
    
    let productService : Persisten = Persisten()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Keranjang"
        
        let nibCell = UINib(nibName: "KeranjangCell", bundle: nil)
        keranjangCollectionView.register(nibCell, forCellWithReuseIdentifier: "keranjangCell")
        
        keranjangCollectionView.dataSource = self
        keranjangCollectionView.delegate = self
        
        print("Produks", products)
        
        totalBelanja.text = String(totalSum)
        
        products = productService.fetchProducts()
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
            landingVC.totalPemabayaran = totalSum
        }
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isHiddenHairline = false
    }
    
}

extension KeranjangViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = keranjangCollectionView.dequeueReusableCell(withReuseIdentifier: "keranjangCell", for: indexPath) as! KeranjangCell
        
        cell.productImage.image = UIImage(data: products[indexPath.row].image_data!)
        cell.productName.text = products[indexPath.row].name
//        cell.productExpired.text = products[indexPath.row].exp_date
        cell.productPrice.text = String(products[indexPath.row].price)
        
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
        print(indexPath)
    }
}
