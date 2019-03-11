//
//  PropertyAnimatorViewController.swift
//  Animations
//
//  Created by Dmytro Dobrovolskyy on 3/6/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class PropertyAnimatorViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var coloredView: UIView!
    @IBOutlet private var collectionsOfButtons: [UIButton]!
    @IBOutlet weak var returnBackLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
            
        // Change color button
        case 0:
            changeColorAnimation()
            
        // Hide button
        case 1:
            hideAnimation()
            
        // Show button
        case 2:
            showAnimation()
            
        default:
            break
        }
    }
    
    // MARK: - Life cyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Buttons actions
    private func changeColorAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.2, options: [.curveEaseOut], animations: {
            self.coloredView.backgroundColor = .lightGray
        })
    }
    
    private func hideAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.coloredView.transform = CGAffineTransform(translationX: 0, y: 1000)
            self.coloredView.alpha = 0
        }) { continuing in
            if continuing == .end {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    self.returnBackLabel.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    private func showAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.coloredView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.coloredView.alpha = 1
        }) { continuing in
            if continuing == .end {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    self.returnBackLabel.alpha = 0
                }, completion: nil)
            }
        }
    }
    
    // MARK: - Components configuration
    private func configure() {
        coloredView.addTapGesture(for: self, with: #selector(dismissView(gesture:)))
        configureButtons()
    }
    
    private func configureButtons() {
        for button in collectionsOfButtons {
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }
    }
    
    // MARK: - Dismiss view controller
    @objc private func dismissView(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
