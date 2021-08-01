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
    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var hargaTF: UITextField!
    @IBOutlet weak var stockTF: UITextField!
    @IBOutlet weak var deskTF: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageThumnail: UIImageView!
    @IBOutlet weak var kadaluwarsaPicker: UIDatePicker!
    
    var selectedItem: ProductItem? = nil
    var scanningBarcode: String? = nil
    var datePicker: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageThumnail.cornerRadius()
        
        addProdItem.cornerRadius(width: 10, height: 4)
        addProdItem.addGradient()
        deleteProdukButton.cornerRadius(width: 10, height: 4)
        deleteProdukButton.cornerRadius()
        
        
        if (selectedItem != nil) {
            namaTF.text = selectedItem?.name
            deskTF.text = selectedItem?.desc
            hargaTF.text = "\(String(describing: selectedItem?.price))"
            imageThumnail.image = UIImage(data: (selectedItem?.image_data)!)
            
        } else {
//            idTF.text = scanningBarcode
        }
        
        kadaluwarsaPicker.datePickerMode = .dateAndTime
        kadaluwarsaPicker.addTarget(self, action: #selector(datePickerValueChanged(sender: )), for: UIControl.Event.valueChanged)
        
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
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        print(sender.date)
        datePicker = sender.date
    }
    
    @IBAction func addImage(_ sender: Any){
        self.takePhotoWithCamera()
    }
    
    @IBAction func addProduct(_ sender: Any){
        print("Saving...")
        
        
        if (selectedItem == nil) {
        guard let codeValue = scanningBarcode else {
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
            
        guard let stock = stockTF.text else {
            print("error harga")
            return
            
        }
        
        guard  let image = imageThumnail.image?.pngData() else {
            print("error image ")
            return
        }
        
        guard let date = datePicker else {
            print("error date")
            return
        }
        
        Persisten.shared.insertProduct(scanValue: codeValue, name: nama, description: desc, price: (price as NSString).floatValue, image: image, expired: date, stock: Int64(stock)!)
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
            
            self.selectedItem?.name = nama
            self.selectedItem?.desc = desc
            self.selectedItem?.price = (price as NSString).floatValue
            self.selectedItem?.image_data = image
            
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

