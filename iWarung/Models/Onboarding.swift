//
//  Onboarding.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 27/07/21.
//

import UIKit

struct Onboarding {
    let image: UIImage
    let label: String
    let description: String
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnboardingCollectionViewCell.self)

    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var slideDescription: UILabel!
    
    func setup(_ slide: Onboarding) {
        self.slideImage.image = slide.image
        self.slideLabel.text = slide.label
        self.slideDescription.text = slide.description
    }
}
