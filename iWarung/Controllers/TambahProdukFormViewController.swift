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
            imageThumnail.image = UIImage(data: (selectedItem?.imageD)!)
            
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
        guard let id = idTF.text else {
            print("erorr id")
            return
        }
        
        guard let nama = namaTF.text else {
            print("error nama")
            return
        }
        
        guard let desc = deskTF.text else {
            print("error deskripsi")
            return
        }
        
        guard let price = hargaTF.text else {
            print("error harga")
            return
        }
        
        guard  let image = imageThumnail.image?.pngData() else {
            print("error image ")
            return
        }
            Persisten.shared.insertProduct(id: id, name: nama, description: desc, price: price, image: image)
            self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            // edit
        } else {
            
            guard let nama = namaTF.text else {
                print("error nama")
                return
            }
            
            guard let desc = deskTF.text else {
                print("error deskripsi")
                return
            }
            
            guard let price = hargaTF.text else {
                print("error harga")
                return
            }
            
            guard  let image = imageThumnail.image?.pngData() else {
                print("error image ")
                return
            }
            
            self.selectedItem?.nama = nama
            self.selectedItem?.deskripsi = desc
            self.selectedItem?.harga = price
            self.selectedItem?.imageD = image
            
            Persisten.shared.saveContext()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteProduk(_ sender: Any) {
        if (selectedItem != nil) {
            Persisten.shared.deleteProduct(item: selectedItem!)
            self.dismiss(animated: true, completion: nil)
        }
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

