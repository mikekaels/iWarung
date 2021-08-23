//
//  DaftarProdukViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 26/07/21.
//

import UIKit
import CoreData

class DaftarProdukSearchResult: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: K.blueColor1)
    }
}

class DaftarProdukViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    
    @IBOutlet weak var daftarProdukCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var segmentedScrollView: UIScrollView!
    
    var firsLoad = true
    var productList = [ProductItem]()
    var dupProductList = [ProductItem]()
    
    let segmentedControlBackgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCustomSegmentedControl()
        segmentedScrollView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        title = "Daftar Produk"
        
        self.searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        let nibCell = UINib(nibName: "KeranjangCell", bundle: nil)
        daftarProdukCollectionView.register(nibCell, forCellWithReuseIdentifier: "keranjangCell")
        
        daftarProdukCollectionView.dataSource = self
        daftarProdukCollectionView.delegate = self
        
        refreshList()
//        self.dupProductList = self.productList
        self.hideKeyboardWhenTappedAround()
        navigationItem.hidesSearchBarWhenScrolling = true
        
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
    
//    @objc func refresh() {
//        loadData();
//    }
//
    
    func formatterDate(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MM-yyyy"
        return formatter.string(from: date).uppercased()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        refreshList()
        daftarProdukCollectionView.reloadData()
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
//        if (segue.identifier == "productDetail"){
//            if let destination = segue.destination as?
//                TambahProdukFormViewController, let index =
//                    daftarProdukCollectionView.indexPathsForSelectedItems?.first {
//                destination.selectedItem = productList[index.row]
//            }
//
//        }
    }
    
}

extension DaftarProdukViewController:  UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc =  UIStoryboard.init(name: "TambahProdukForm", bundle: Bundle.main).instantiateViewController(withIdentifier: "TambahProdukForm") as! TambahProdukFormViewController
        vc.selectedItem = dupProductList[indexPath.row]
        print("PRODUK: ",dupProductList[indexPath.row])
        vc.isNewProduct = false
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dupProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = daftarProdukCollectionView.dequeueReusableCell(withReuseIdentifier: "keranjangCell", for: indexPath) as! KeranjangCell
        
        let item: ProductItem = self.dupProductList[indexPath.row]
        
        
        cell.productImage.image = UIImage(data: item.image_data!)
        cell.productName.text = item.name
        cell.productPrice.text = String(item.price).currencyFormatting()
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
}

extension DaftarProdukViewController: ProdukFormDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        self.refreshList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.refreshList()
    }
    
    func update() {
        refreshList()
    }
    
    func delete(item: ProductItem) {
        Persisten.shared.deleteProduct(item: item)
        refreshList()
    }
    
    func refreshList() {
        productList = Persisten.shared.fetchProducts()
        self.dupProductList = self.productList
        self.daftarProdukCollectionView.reloadData()
    }
}

extension DaftarProdukViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else{
            return
        }
        
        self.dupProductList = text.isEmpty ? self.productList : productList.filter({ Product in
            return Product.name!.range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil
        })

        self.daftarProdukCollectionView.reloadData()
    }
}

extension DaftarProdukViewController {
    
    @objc func handleSegmentedControlButtons(sender: UIButton) {
        let segmentedControlButtons: [UIButton] = [
            K.allProducts,
            K.popular,
            K.expired,
            K.firstAdded,
            K.lastAdded
        ]
        
        for button in segmentedControlButtons {
            if button == sender {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) {
                    button.setTitleColor(UIColor(rgb: K.blueColor1), for: .normal)
                    button.titleLabel?.font = K.segmentedButtonSelected
                }
                
                print(button.titleLabel!.text!)
                
                
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) {
                    button.setTitleColor(K.greyLight, for: .normal)
                    button.titleLabel?.font = K.segmentedButton
                    
                }
            }
        }
        
    }
    
    func configureCustomSegmentedControl() {
        let segmentedControlButtons: [UIButton] = [
            K.allProducts,
            K.popular,
            K.expired,
            K.firstAdded,
            K.lastAdded
        ]
        
        for button in segmentedControlButtons {
            if button.titleLabel!.text! == "Semua Produk" {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) {
                    button.setTitleColor(UIColor(rgb: K.blueColor1), for: .normal)
                    button.titleLabel?.font = K.segmentedButtonSelected
                }
            }
        }
        
        segmentedControlButtons.forEach {$0.addTarget(self, action: #selector(handleSegmentedControlButtons(sender:)), for: .touchUpInside)}
        
        let stackView = UIStackView(arrangedSubviews: segmentedControlButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //            stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true;
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        segmentedScrollView.addSubview(stackView)
        
        segmentedScrollView.contentInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20)
        
        NSLayoutConstraint.activate([
            //                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //                scrollView.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: segmentedScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: segmentedScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: segmentedScrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
}
