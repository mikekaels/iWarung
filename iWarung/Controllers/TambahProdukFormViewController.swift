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
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var hargaTF: UITextField!
    @IBOutlet weak var deskTF: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageThumnail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        imageThumnail.cornerRadius()
        
        
        addProdItem.cornerRadius(width: 10, height: 4)
        addProdItem.addGradient()
        
        idTF.text = "1878437298"
        
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
        
    }
    
    func onButtonTapped() {
        self.performSegue(withIdentifier: "backToMainController", sender: self)
    }

}

//UIImagePickerControllerDelegate, UINavigationControllerDelegate
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

