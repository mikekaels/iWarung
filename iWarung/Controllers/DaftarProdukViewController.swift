//
//  DaftarProdukViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 26/07/21.
//

import UIKit

class DaftarProdukViewController: UIViewController {
    @IBOutlet weak var daftarProdukCollectionView: UICollectionView!
    
    let products: [Product] = [
        Product(image: "bimoli", name: "Bimoli 2L", expired: "20-05-2022", price: 24000),
        Product(image: "gulaku", name: "Gulaku", expired: "15-03-2025", price: 18000),
        Product(image: "blue band", name: "Blue Band", expired: "31-01-2028", price: 30000),
        Product(image: "bimoli", name: "Bimoli 2L", expired: "20-05-2022", price: 24000),
        Product(image: "gulaku", name: "Gulaku", expired: "15-03-2025", price: 18000),
        Product(image: "blue band", name: "Blue Band", expired: "31-01-2028", price: 30000),
        Product(image: "bimoli", name: "Bimoli 2L", expired: "20-05-2022", price: 24000),
        Product(image: "gulaku", name: "Gulaku", expired: "15-03-2025", price: 18000),
        Product(image: "blue band", name: "Blue Band", expired: "31-01-2028", price: 30000)
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Daftar Produk"
        // Do any additional setup after loading the view.
        
        let nibCell = UINib(nibName: "KeranjangCell", bundle: nil)
        daftarProdukCollectionView.register(nibCell, forCellWithReuseIdentifier: "keranjangCell")
        
        daftarProdukCollectionView.dataSource = self
        daftarProdukCollectionView.delegate = self
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DaftarProdukViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = daftarProdukCollectionView.dequeueReusableCell(withReuseIdentifier: "keranjangCell", for: indexPath) as! KeranjangCell
        
        cell.productImage.image = UIImage(named: products[indexPath.row].image)
        cell.productName.text = products[indexPath.row].name
        cell.productExpired.text = products[indexPath.row].expired
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
