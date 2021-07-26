import UIKit

var productList = [Item]()

class ProductTableView: UITableViewController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let prodCell = tableView.dequeueReusableCell(withIdentifier: "prodCell", for: indexPath) as! ProductViewCell
        
        let thisProduct: Item!
        thisProduct = productList[indexPath.row]
        
        prodCell.namaLabel.text = thisProduct.nama
        prodCell.hargaLabel.text = thisProduct.harga
        prodCell.imageView?.image = UIImage(data: thisProduct.imageD!)
        
        return prodCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}
