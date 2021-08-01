//
//  CameraInactivePopUpViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 01/08/21.
//

import UIKit

class CameraInactivePopUpViewController: UIViewController, SBCardPopupContent {
    var popupDismisser: SBCardPopupDismisser?
    
    var allowsTapToDismissPopupCard: Bool = true
    
    var allowsSwipeToDismissPopupCard: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        self.view.addGestureRecognizer(tapGesture)
    }
    

    static func create() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CameraInactivePopUp") as! CameraInactivePopUpViewController
        return storyboard
    }
    
    @objc func dismissVC() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        self.dismiss(animated: true, completion: {
            DispatchQueue.main.async(execute: { () -> Void in
                NotificationCenter.default.post(name: NSNotification.Name(K.NSpopUpDismissed), object: nil)
            })
        })
    }
    
    
}
