//
//  TambahProdukFormViewController.swift
//  iWarung
//
//  Created by Miftahul Jihad on 26/07/21.
//

import UIKit
import CoreData
import UserNotifications

protocol ProdukFormDelegate {
    func update()
    func delete(item: ProductItem)
}

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
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var ketukText: UILabel!
    @IBOutlet weak var canceldeleteButton: UIButton!
    @IBOutlet weak var errorTextLabel: UILabel!
    
    @IBOutlet var textFields: [UITextField]!
    
    var selectedItem: ProductItem?
    var scanningBarcode: String? = ""
    var datePicker: Date!
    let datePickerView = UIDatePicker()
    var isNewProduct = false
    
    let center = UNUserNotificationCenter.current()
    
    var delegate: ProdukFormDelegate!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.imageBackgroundView.addDashedBorder()
        self.hideKeyboardWhenTappedAround()
        imageThumnail.cornerRadius()
        
        
        addProdItem.cornerRadius()
        addProdItem.addGradient()
        addProdItem.setTitle("Simpan", for: .normal)
        
        createDatePicker()
        
        if (selectedItem != nil) {
            cameraIcon.isHidden = true
            ketukText.isHidden = true
            
            namaTF.text = selectedItem!.name
            
            hargaTF.text = String(selectedItem!.price).currencyFormatting()
            stockTF.text = "\(selectedItem!.stock)"
            kadaluwarsaTF.text = formatterDate(deadline: (selectedItem?.exp_date)!)
            imageThumnail.image = UIImage(data: (selectedItem?.image_data)!)

            addProdItem.setTitle("Simpan Perubahan", for: UIControl.State.normal)
            
            canceldeleteButton.setTitle("Hapus", for: UIControl.State.normal)

        } else {
//            deleteProdukButton.isHidden = true
        }
//
//        kadaluwarsaPicker.datePickerMode = .dateAndTime
//        kadaluwarsaPicker.addTarget(self, action: #selector(datePickerValueChanged(sender: )), for: UIControl.Event.valueChanged)
//
//        self.setupHideKeyboardOnTap()
        buttonSetup()
        errorLabelSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    fileprivate func errorLabelSetup() {
        addProdItem.tintColor = .red
        errorTextLabel.isHidden = true
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        var formIsValid = true

        for textField in textFields {
            // Validate Text Field
            let (valid, _) = validate(textField)

            guard valid else {
                formIsValid = false
                break
            }
        }

        // Update Save Button
        errorTextLabel.isHidden = formIsValid
    }
    
    func buttonSetup(){
        if isNewProduct {
            canceldeleteButton.setTitle("Batalkan", for: .normal)
            canceldeleteButton.addTarget(self, action: #selector(cancelForm), for: .touchUpInside)
        } else {
            canceldeleteButton.setTitle("Hapus", for: .normal)
            canceldeleteButton.addTarget(self, action: #selector(deleteProduct), for: .touchUpInside)
        }
    }
    
    @objc func deleteProduct(){
        print("SELECTED: ",type(of: selectedItem?.id))
//        Persisten.shared.deleteProduct(item: selectedItem!)
        self.delegate.delete(item: selectedItem!)
        self.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
        
    
    @objc func cancelForm(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func formatterDate(deadline: Date) -> String {
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let data = deadline.days(from: dateNow)
        
        if (data >= 30) {
            return formatter.string(from: deadline)
        } else if (data < 0) {
            return formatter.string(from: deadline)
        }
        return "\(data+1) days left"
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
            
            let content = UNMutableNotificationContent()
            content.title = "Info product Kadaluwarsa"
            content.body = nama
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100)
            
            let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            center.add(request) { (error) in
                print("Error adding notification because \(String(describing: error))")
            }
        
            Persisten.shared.insertProduct(scanValue: codeValue, name: nama, description: "deskripsi", price: (price as NSString).floatValue, image: image, expired: date, stock: Int64(stock)!, min_stock: 5)
            
            self.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            
            guard let nama = namaTF.text else {
                print("error nama")
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
            
            let date = datePickerView.date
            
            self.selectedItem?.name = nama
            self.selectedItem?.price = (price as NSString).floatValue
            self.selectedItem?.image_data = image
            self.selectedItem?.stock = Int64(stock)!
            
            let content = UNMutableNotificationContent()
            content.title = "Info product Kadaluwarsa"
            content.body = nama
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100)
            
            let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            center.add(request) { (error) in
                print("Error adding notification because \(String(describing: error))")
            }
            
            Persisten.shared.saveContext()
            delegate.update()
            self.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
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
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let userPickedImage = info[.originalImage] as? UIImage else { return }
        imageThumnail.image = userPickedImage.upOrientationImage()
        picker.dismiss(animated: true)
        if (imageThumnail.image != nil) {
            cameraIcon.isHidden = true
            ketukText.isHidden = true
            self.imageBackgroundView.layer.sublayers!
                .filter { $0.name == "dash-border" }
                .forEach { $0.removeFromSuperlayer() }
        }
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
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        kadaluwarsaTF.text = formatter.string(from: datePickerView.date)
        self.view.endEditing(true)
    }
}

//MARK: - TextField Delegate

extension TambahProdukFormViewController: UITextFieldDelegate {
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case namaTF:
                let (valid, message) = validate(textField)
                
                if valid {
                    hargaTF.becomeFirstResponder()
                }
                
                self.errorTextLabel.text = message
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.errorTextLabel.isHidden = valid
                })
            case hargaTF:
                stockTF.becomeFirstResponder()
            case stockTF:
                kadaluwarsaTF.becomeFirstResponder()
            default:
                kadaluwarsaTF.resignFirstResponder()
            }
        
            return true
    }
    
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }

        if textField == namaTF {
            return (text.count > 0, "Nama produk tidak boleh kosong")
        } else if textField == hargaTF {
            return (text.count > 0, "Harga produk tidak boleh kosong")
        } else if textField == stockTF {
            return (text.count >= 0, "Stok barang tidak boleh minus")
        } else if textField == kadaluwarsaTF {
            return (text.count > 0, "Tanggal kadaluwarsa tidak boleh kosong")
        }

        return (text.count > 0, "This field cannot be empty.")
    }
}
