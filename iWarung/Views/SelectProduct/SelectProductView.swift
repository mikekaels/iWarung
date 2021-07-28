//
//  SelectProductView.swift
//  iWarung
//
//  Created by Muhammad Firdaus on 28/07/21.
//

import UIKit

class SelectProductView: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        setupCollectionView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Abcd", style: .done, target: self, action: #selector(backAction))
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "KeranjangCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "keranjangCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension SelectProductView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keranjangCell", for: indexPath) as! KeranjangCell
        
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
