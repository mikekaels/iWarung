//
//  TambahProdukFormViewController.swift
//  iWarung
//
//  Created by Miftahul Jihad on 26/07/21.
//

import UIKit
import CoreData

class TambahProdukFormViewController: UIViewController{
    
    
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var addProdItem: UIButton!
    @IBOutlet weak var deleteProdukButton: UIButton!
    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var hargaTF: UITextField!
    @IBOutlet weak var stockTF: UITextField!
    @IBOutlet weak var kadaluwarsaTF: UITextField!
    @IBOutlet weak var deskTF: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageThumnail: UIImageView!
    @IBOutlet weak var kadaluwarsaPicker: UIDatePicker!
    
    var selectedItem: ProductItem? = nil
    var scanningBarcode: String? = ""
    var datePicker: Date!
    let datePickerView = UIDatePicker()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.imageBackgroundView.addDashedBorder()
        self.hideKeyboardWhenTappedAround()
        imageThumnail.cornerRadius()
        
        
        addProdItem.cornerRadius()
        addProdItem.addGradient()
        addProdItem.setTitle("Simpan", for: .normal)
        
        createDatePicker()
//        addProdItem.cornerRadius(width: 10, height: 4)
//        addProdItem.addGradient()
//        deleteProdukButton.cornerRadius(width: 10, height: 4)
//        deleteProdukButton.cornerRadius()
        
//
//        if (selectedItem != nil) {
//            namaTF.text = selectedItem?.name
//            deskTF.text = selectedItem?.desc
//            hargaTF.text = "\(selectedItem?.price ?? 0)"
//            stockTF.text = "\(selectedItem?.stock ?? 0)"
//            kadaluwarsaPicker.date = (selectedItem?.exp_date!)!
//            imageThumnail.image = UIImage(data: (selectedItem?.image_data)!)
//
//            addProdItem.setTitle("Simpan Perubahan", for: UIControl.State.normal)
//
//        } else {
//            deleteProdukButton.isHidden = true
//        }
//
//        kadaluwarsaPicker.datePickerMode = .dateAndTime
//        kadaluwarsaPicker.addTarget(self, action: #selector(datePickerValueChanged(sender: )), for: UIControl.Event.valueChanged)
//
//        self.setupHideKeyboardOnTap()
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
        
//        guard let desc = deskTF.text else {
//            print("error deskripsi")
//            return
//        }
        
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
        
        let date = datePickerView.date
        
        Persisten.shared.insertProduct(scanValue: codeValue, name: nama, description: "deskripsi", price: (price as NSString).floatValue, image: image, expired: date, stock: Int64(stock)!)
            self.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
            
//            manager?.productItem.name = nama
////            manager?.productItem.desc = desc
//            manager?.productItem.barcode_value = codeValue
//            manager?.productItem.exp_date = date
//            manager?.productItem.price = (price as NSString).floatValue
//            manager?.productItem.stock = Int64(stock)!
//            manager?.productItem.image_data = image
//            manager?.updateData(onSuccess: {
//                print("Berhasil ditambahkan")
//                self.dismiss(animated: true, completion: nil)
//            }, onError: {
//                print("Gagal ditambahkan")
//            })
//
            
            // edit
        } else {
            
            guard let nama = namaTF.text else {
                print("error nama")
                return
            }
            
//            guard let desc = deskTF.text else {
//                print("error deskripsi")
//                return
//            }
            
            guard let price = hargaTF.text else {
                print("error harga")
                return
            }
            
            guard  let image = imageThumnail.image?.pngData() else {
                print("error image ")
                return
            }
            
            self.selectedItem?.name = nama
//            self.selectedItem?.desc = desc
            self.selectedItem?.price = (price as NSString).floatValue
            self.selectedItem?.image_data = image
            
            Persisten.shared.saveContext()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteProduk(_ sender: Any) {
        if (selectedItem != nil) {
            Persisten.shared.deleteProduct(item: selectedItem!)
            self.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
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

//MARK: - DATE PICKER
extension TambahProdukFormViewController {
    // toolbar
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(inputDate))
        
        toolbar.setItems([doneBtn], animated: true)
        
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.datePickerMode = .date
        
        // assign toolbar
        kadaluwarsaTF.inputAccessoryView = toolbar
        kadaluwarsaTF.inputView = datePickerView
    }
    
    @objc func inputDate() {
        kadaluwarsaTF.text = "\(datePickerView.date)"
        self.view.endEditing(true)
    }
}
