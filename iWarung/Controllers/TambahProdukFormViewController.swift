//
//  TambahProdukFormViewController.swift
//  iWarung
//
//  Created by Miftahul Jihad on 26/07/21.
//

import UIKit
import CoreData

class TambahProdukFormViewController: UIViewController {

    @IBOutlet weak var addProdItem: UIButton!
    @IBOutlet weak var deleteProdukButton: UIButton!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var hargamodalTF: UITextField!
    @IBOutlet weak var hargaTF: UITextField!
    @IBOutlet weak var stockTF: UITextField!
    @IBOutlet weak var deskTF: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageThumnail: UIImageView!
    
    var selectedItem: Item? = nil
    var scanningBarcode: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        imageThumnail.cornerRadius()
        
        addProdItem.cornerRadius(width: 10, height: 4)
        addProdItem.addGradient()
        deleteProdukButton.cornerRadius(width: 10, height: 4)
        deleteProdukButton.cornerRadius()
        
        
        if (selectedItem != nil) {
            idTF.text = "\(String(describing: selectedItem?.id))"
            namaTF.text = selectedItem?.nama
            deskTF.text = selectedItem?.deskripsi
            hargaTF.text = selectedItem?.harga
            
        } else {
            idTF.text = scanningBarcode
        }
        
        self.setupHideKeyboardOnTap()
    }
    
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
        func setupHideKeyboardOnTap() {
           self.view.addGestureRecognizer(self.endEditingRecognizer())
           self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
       }

       /// Dismisses the keyboard from self.view
       private func endEditingRecognizer() -> UIGestureRecognizer {
           let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
           tap.cancelsTouchesInView = false
           return tap
       }
    
    @IBAction func addImage(_ sender: Any){
        self.takePhotoWithCamera()
    }
    
    @IBAction func addProduct(_ sender: Any){
        print("Saving...")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if (selectedItem == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
            let newProduct = Item(entity: entity!, insertInto: context)
            
            newProduct.imageD = imageThumnail.image?.pngData()
            newProduct.id = Int32(truncating: productList.count as NSNumber)
            newProduct.nama = namaTF.text
            newProduct.harga = hargaTF.text
            newProduct.deskripsi = deskTF.text
            
            do {
                try context.save()
                productList.append(newProduct)
                dismiss(animated: true)
    //            navigationController?.popViewController(animated: true)
                print("Saved")
            } catch {
                print("error saving dataa")
            }
            
            // edit
        } else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let item = result as! Item
                    if (item == selectedItem) {
                        item.id = Int32(truncating: productList.count as NSNumber)
                        item.nama = namaTF.text
                        item.harga = hargaTF.text
                        item.deskripsi = deskTF.text
                        item.imageD = imageThumnail.image?.pngData()
                        try context.save()
                        dismiss(animated: true)
                    }
                }
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    @IBAction func deleteProduk(_ sender: Any) {
        
    }
    
    func onButtonTapped() {
        self.performSegue(withIdentifier: "backToMainController", sender: self)
    }

}


extension TambahProdukFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        imageThumnail.image = userPickedImage
        picker.dismiss(animated: true)
        
        
    }
}

