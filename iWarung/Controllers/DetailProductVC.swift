

import UIKit
import CoreData

class DetailProductVC: UIViewController {

    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var hargaTF: UITextField!
    @IBOutlet weak var deskTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        print("Saving...")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let newProduct = Item(entity: entity!, insertInto: context)
        
        newProduct.id = Int32(productList.count as NSNumber)
        newProduct.nama = namaTF.text
        newProduct.harga = hargaTF.text
        newProduct.deskripsi = deskTF.text
        
        do {
            print("skskks")
            try context.save()
            productList.append(newProduct)
            navigationController?.popViewController(animated: true)
            print("AHAHAHA")
        } catch {
            print("error saving dataa")
        }
    }

}
