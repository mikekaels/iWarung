

import UIKit
import CoreData

class DetailProductVC: UIViewController {

    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var hargaTF: UITextField!
    @IBOutlet weak var deskTF: UITextField!
    @IBOutlet weak var imageDT: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.endEditing(true)
    }
    
    @IBAction func addImage(_ sender:Any) {
        self.takePhotoWithCamera()
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        print("Saving...")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let newProduct = Item(entity: entity!, insertInto: context)
        
        newProduct.imageD = imageDT.image?.pngData()
        newProduct.id = Int32(productList.count as NSNumber)
        newProduct.nama = namaTF.text
        newProduct.harga = hargaTF.text
        newProduct.deskripsi = deskTF.text
        
        do {
            try context.save()
            productList.append(newProduct)
            navigationController?.popViewController(animated: true)
            print("Saved")
        } catch {
            print("error saving dataa")
        }
    }

}

extension DetailProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        imageDT.image = userPickedImage
        picker.dismiss(animated: true)
        
        
    }
}
