//
//  TransaksiSelesaiPasView.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 25/07/21.
//

import UIKit

protocol TransaksiSelesaiDelegate {
    func backToRoot()
    func openRecipt()
}

class TransaksiSelesaiPasView: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var delegate: TransaksiSelesaiDelegate!
    
    @IBOutlet weak var cetakStrukButton: UIButton!
    @IBOutlet weak var backToMainScreenButton: UIButton!
    @IBOutlet weak var slideIndicator: UIView!
    @IBOutlet weak var successBackground: UIImageView!
    @IBOutlet weak var successForeground: UIImageView!
    
    @IBAction func backToMainScreenPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate.backToRoot()
    }
    
    @IBAction func cetakStrukTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate.openRecipt()
    }
    
    
    override func viewDidLayoutSubviews() {
        successLogoAnimate()
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
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
    
    func successLogoAnimate() {
        let foregroundResize: CGFloat = 40
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.successBackground.rotate(angle: 90)
        }, completion: nil)
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat,], animations: {
            self.successForeground.frame = CGRect(x: -CGFloat(foregroundResize / 2),
                                                  y: -CGFloat(foregroundResize / 2),
                                                  width: self.successForeground.frame.width + foregroundResize,
                                                  height: self.successForeground.frame.height + foregroundResize)
        }, completion: nil)
        
    }
}

extension TransaksiSelesaiPasView {
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        self.slideIndicator.cornerRadius(width: 5, height: 5)
        
        //MARK: - buttons
        cetakStrukButton.cornerRadius()
        cetakStrukButton.tintColor = UIColor(rgb: K.blueColor1)
//        cetakStrukButton.addGradient()
        
        //MARK: - buttons
        backToMainScreenButton.cornerRadius()
        backToMainScreenButton.addGradient()
    }
}
