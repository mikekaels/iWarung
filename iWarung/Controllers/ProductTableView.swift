import UIKit

var productList = [Item]()

class ProductTableView: UITableViewController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let prodCell = tableView.dequeueReusableCell(withIdentifier: "prodCellID", for: indexPath) as! ProductCell
        
        let thisProduct: Item!
        thisProduct = productList[indexPath.row]
        
        prodCell.namaLabel.text = thisProduct.nama
        prodCell.hargaLabel.text = thisProduct.harga
        
        return prodCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}
