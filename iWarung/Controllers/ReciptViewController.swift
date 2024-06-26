//
//  ReciptViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 10/08/21.
//

import UIKit

class ReciptViewController: UIViewController {
    
    @IBOutlet weak var reciptTableView: UITableView!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var receiptIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var keranjang = [ItemKeranjang]()
    var uang: Float = 0
    var kembalian: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("KERANJANG: ",keranjang)
        
        receiptSetup()
        // Do any additional setup after loading the view.
        bottomLine.addDashedLineBorder(color: UIColor(rgb: K.blueColor1))
        
        self.reciptTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let nibList = UINib(nibName: "ReciptListProductTableViewCell", bundle: nil)
        reciptTableView.register(nibList, forCellReuseIdentifier: "reciptListProduct")
        
        let nibFooter = UINib(nibName: "ReciptFooterTableViewCell", bundle: nil)
        reciptTableView.register(nibFooter, forCellReuseIdentifier: "reciptFooter")
        

        self.reciptTableView.beginUpdates()
        self.reciptTableView.insertRows(at: [IndexPath.init(row: self.keranjang.count - 1, section: 0)], with: .automatic)
        self.reciptTableView.endUpdates()
        
        reciptTableView.dataSource = self
        reciptTableView.delegate = self
    }
    @IBAction func shareTapped(_ sender: UIButton) {
        print("clicked")
        self.createPDFTap()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: K.clearKeranjangNotificationKey, object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func receiptSetup() {
        self.dateLabel.text = K.getOnlyDate()
        self.timeLabel.text = K.getOnlyTime()
    }
}

extension ReciptViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keranjang.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("INDEX: ",indexPath)
        if indexPath.row < keranjang.count {
            let cell = reciptTableView.dequeueReusableCell(withIdentifier: "reciptListProduct", for: indexPath) as! ReciptListProductTableViewCell
            let item = keranjang[indexPath.row]
            cell.commonInit(qty: item.qty, productName: item.name, totalPrice: item.total)
            return cell
        } else {
            let cell = reciptTableView.dequeueReusableCell(withIdentifier: "reciptFooter", for: indexPath) as! ReciptFooterTableViewCell
            cell.commonInit(totalBelanja: K.totalPrice(keranjang: keranjang), uang: self.uang, kembalian: self.kembalian)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(indexPath.row, keranjang.count)
        return indexPath.row == keranjang.count ? CGFloat(200) : CGFloat(30)
    }
}

extension ReciptViewController {
    func createPDFTap() {
        print("Here...")
        let pdfFilePath = self.pdfView.exportAsPdfFromView()
        
        let fileManager = FileManager.default
        
        let documentoPath = pdfFilePath
        
        if fileManager.fileExists(atPath: documentoPath){
            
          let url = URL(fileURLWithPath: documentoPath)
            
          let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
          activityViewController.popoverPresentationController?.sourceView=self.view
            
          self.present(activityViewController, animated: true, completion: nil)
            
        }else {
            
           print("Something Went Wrong")
            
        }
    }
}
