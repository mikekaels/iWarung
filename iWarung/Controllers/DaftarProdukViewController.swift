//
//  DaftarProdukViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 26/07/21.
//

import UIKit
import CoreData

class DaftarProdukViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var daftarProdukCollectionView: UICollectionView!
    
    
    var firsLoad = true
    var productList = [ProductItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Daftar Produk"
        // Do any additional setup after loading the view.
        
        let nibCell = UINib(nibName: "KeranjangCell", bundle: nil)
        daftarProdukCollectionView.register(nibCell, forCellWithReuseIdentifier: "keranjangCell")
        
        daftarProdukCollectionView.dataSource = self
        daftarProdukCollectionView.delegate = self
        
        loadData()
        self.hideKeyboardWhenTappedAround()
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
        
        let cell = daftarProdukCollectionView.dequeueReusableCell(withReuseIdentifier: "keranjangCell", for: indexPath) as! KeranjangCell
        
        let item: ProductItem!
        item = productList[indexPath.row]
        
        cell.productImage.image = UIImage(data: item.image_data!)
        cell.productName.text = item.name
        cell.productPrice.text = String(item.price)
        cell.productExpired.text = formatterDate(with: item.exp_date!)
        cell.totalProduk = Int(item.stock)
        cell.totalProductLabel.text = String(cell.totalProduk)
        cell.plusButton.isHidden = true
        cell.minusButton.isHidden = true
        
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
    
//    func formatterDate(deadline: Date) -> String {
//        let dateNow = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM d, yyyy"
//        let data = deadline.days(from: dateNow)
//
//        if (data >= 30) {
//            return formatter.string(from: deadline)
//        } else if (data < 0) {
//            return formatter.string(from: deadline)
//        }
//        return "Exp. \(data+1) days left"
//    }
    
    func formatterDate(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MM-yyyy"
        return formatter.string(from: date).uppercased()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        daftarProdukCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "productDetail", sender: self)
    }
    
    @IBAction func tambahProdukPressed(_ sender: Any) {
//        let slideVC = TambahProdukScanViewController()
//        slideVC.modalPresentationStyle = .popover
////        slideVC.transitioningDelegate = self
//        self.present(slideVC, animated: true, completion: { () in
//            print("Modal opened")
//        })
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
