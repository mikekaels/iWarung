//
//  OnboardingViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 27/07/21.
//

import UIKit

class OnboardingViewController: UIViewController{

    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var mulaiButton: UIButton!
    
    var currentPage = 0 {
        didSet {
            pageCtrl.currentPage = currentPage
            if currentPage == K.onboardingSlides.count - 1 {
                self.mulaiButton.isHidden = false
                self.nextPageButton.isHidden = true
                self.skipButton.isHidden = true
                
                UIView.animate(withDuration: 0.5) {
                    self.mulaiButton.alpha = 1
                    self.nextPageButton.alpha = 0
                    self.skipButton.alpha = 0
                }
            } else {
                self.mulaiButton.isHidden = true
                self.nextPageButton.isHidden = false
                self.skipButton.isHidden = false
                
                UIView.animate(withDuration: 0.3) {
                    self.mulaiButton.alpha = 0
                    self.skipButton.alpha = 1
                }
                
                UIView.animate(withDuration: 0.5) {
                    self.nextPageButton.alpha = 1
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mulaiButton.isHidden = true
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        self.mulaiButton.alpha = 0
    }
    
    func notNewUser() {
        Core.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Actions
    @IBAction func nextPagePressed(_ sender: UIButton) {
        if currentPage == K.onboardingSlides.count - 1 {
            notNewUser()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func mulaiButtonPressed(_ sender: UIButton) {
        if currentPage == K.onboardingSlides.count - 1 {
            notNewUser()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension OnboardingViewController {
    override func viewWillAppear(_ animated: Bool) {
        skipButton.tintColor = UIColor(rgb: K.blueColor1)
        
        nextPageButton.cornerRadius(width: 10, height: 10)
        nextPageButton.addGradient()
        
        mulaiButton.setTitle("Mulai", for: .normal)
        mulaiButton.cornerRadius(width: 10, height: 10)
        mulaiButton.addGradient()
    }
    
}

//MARK: - Delegate and Data Source
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.onboardingSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(K.onboardingSlides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

