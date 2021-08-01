//
//  DaftarProdukViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 26/07/21.
//

import UIKit
import CoreData

var productList = [ProductItem]()

class DaftarProdukViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var daftarProdukCollectionView: UICollectionView!
    
    var firsLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Daftar Produk"
        // Do any additional setup after loading the view.
        
        let nibCell = UINib(nibName: "ProductItemViewCell", bundle: nil)
        daftarProdukCollectionView.register(nibCell, forCellWithReuseIdentifier: "productItemCell")
        
        daftarProdukCollectionView.dataSource = self
        daftarProdukCollectionView.delegate = self
        
        loadData()
    }
    
    @objc func loadData(){
        
        productList = Persisten.shared.fetchProducts()
        daftarProdukCollectionView.reloadData()
        
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
    
    @objc func refresh() {
        self.daftarProdukCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = daftarProdukCollectionView.dequeueReusableCell(withReuseIdentifier: "productItemCell", for: indexPath) as! ProductItemViewCell
        
        let item: ProductItem!
        item = productList[indexPath.row]
        
        cell.productImage.image = UIImage(data: item.image_data!)
        cell.productName.text = item.name
        cell.productDesc.text = item.desc
        cell.productPrice.text = String("Rp.\(item.price)")
        cell.productStock.text = String("Stock \(item.stock)")
        cell.productExpired.text = formatterDate(deadline: item.exp_date!)
        
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
    
    func formatterDate(deadline: Date) -> String {
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let data = deadline.days(from: dateNow)
        
        if (data >= 30) {
            return formatter.string(from: deadline)
        } else if (data < 0) {
            return formatter.string(from: deadline)
        }
        return "Exp. \(data+1) days left"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        daftarProdukCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "productDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "productDetail"){
            
            
            if let destination = segue.destination as?
                    TambahProdukFormViewController, let index =
                    daftarProdukCollectionView.indexPathsForSelectedItems?.first {
                    destination.selectedItem = productList[index.row]
                }
            
        }
    }
    
}


extension Date {
    func days(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    func adding(weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
}
