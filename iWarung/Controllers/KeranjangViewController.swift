//
//  KeranjangViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 23/07/21.
//

import UIKit

class KeranjangViewController: UIViewController {
    @IBOutlet weak var keranjangCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Keranjang"
        
        
    }
    

    

}

//MARK: - Large title, Back Button
extension KeranjangViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        //MARK: - Change back button title to Kembali
        navigationController?.navigationBar.backItem?.title = "kembali"
    }
}

extension KeranjangViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
