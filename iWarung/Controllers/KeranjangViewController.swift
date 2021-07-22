//
//  KeranjangViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 23/07/21.
//

import UIKit

class KeranjangViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Keranjang"
        // Do any additional setup after loading the view.
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

