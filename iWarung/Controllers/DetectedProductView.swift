//
//  DetectedProductView.swift
//  iWarung
//
//  Created by Muhammad Firdaus on 26/07/21.
//

import UIKit

class DetectedProductView: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var productItem: ProductItem!
    
    var qty: Int? = 0
    var total: Float? = 0.0
    
    @IBOutlet weak var slideIndicator: UIView!
    @IBOutlet weak var titleProductLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceProductLabel: UILabel!
    @IBOutlet weak var priceBackground: UIView!
    @IBOutlet weak var dateExpiredLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityBackground: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        productImage.layer.cornerRadius = 25
        
        if productItem != nil {
            titleProductLabel.text = productItem.name
            productImage.image = UIImage(data: productItem.image_data!)
            priceProductLabel.text = "Rp.\(String(productItem.price))"
            dateExpiredLabel.text = formatterDate(deadline: productItem.exp_date!)
            
        }
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
        return "Exp. \(data+1) days left"
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @IBAction func addToCartAction(_ sender: Any) {
        qty = 1;
        total = Float(qty!) * productItem.price
        
        itemsKeranjang.append(ItemKeranjang(image: productItem.image_data!, name: productItem.name!, expired: productItem.exp_date!, price: productItem.price, qty: qty!, total: total!))
        dismiss(animated: true)
    }
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            UIColor.purple.cgColor,
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor,
            UIColor.red.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
        gradient.endPoint = CGPoint(x: 1, y: endY)
        return gradient
    }()
}

extension DetectedProductView {
    // MARK: Setup about view like panGesture, cornerRadius, addGradient and etc
    func setupView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        self.slideIndicator.cornerRadius(width: 5, height: 5)
        
        priceBackground.layer.cornerRadius = 6
        quantityBackground.layer.cornerRadius = 7
        //MARK: - Add To Cart Button
        addToCartButton.cornerRadius()
        addToCartButton.addGradient()
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
