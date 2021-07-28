//
//  DaftarProdukViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 26/07/21.
//

import UIKit
import CoreData

var productList = [Item]()

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
    
    private func loadData(){
        if (firsLoad){
            firsLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let item = result as! Item
                    productList.append(item)
                }
            } catch {
                print("Fetch failed")
            }
        }
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = daftarProdukCollectionView.dequeueReusableCell(withReuseIdentifier: "productItemCell", for: indexPath) as! ProductItemViewCell
        
        let item: Item!
        item = productList[indexPath.row]
        
        cell.productImage.image = UIImage(data: item.imageD!)
        cell.productName.text = item.nama
        cell.productDesc.text = item.deskripsi
        cell.productPrice.text = item.harga
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if productList.isEmpty {
            print("data count \(productList.count)")
        } else {
            print("CoreData \(String(describing: productList[0].nama))")
        }
        
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
