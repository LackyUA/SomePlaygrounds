//
//  ViewController.swift
//  Animations
//
//  Created by Dmytro Dobrovolskyy on 3/5/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class AnimateViewController: UIViewController {
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var circle: UIView!
    @IBOutlet private weak var returnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        self.view.addTapGesture(for: self, with: #selector(chainingAnimation(gesture:)))
    }
    
    // MARK: - Animations
    @objc private func chainingAnimation(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .changed:
            fallthrough
        case .ended:
            view.removeGestureRecognizer(gesture)
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: [], animations: {
                self.firstAnimation()
            }) { (_) in
                UIView.animate(withDuration: 1.0, delay: 0.3, animations: {
                    self.secondAnimation()
                }, completion: { (_) in
                    self.view.addTapGesture(for: self, with: #selector(self.dismissView(gesture:)))
                })
            }
        default:
            break
        }
        
    }
    
    private func firstAnimation() {
        circle.backgroundColor = UIColor.white
        image.center = view.center
        
        let rotate = CGAffineTransform(rotationAngle: CGFloat.pi)
        let scale = CGAffineTransform(scaleX: 3, y: 3)
        circle.transform = scale.concatenating(rotate)
    }
    
    private func secondAnimation() {
        let translate = CGAffineTransform(translationX: 0, y: 0)
        circle.transform = translate
        
        returnLabel.alpha = 1
    }
    
    // MARK: - Components configuration
    private func configureComponents() {
        configureImage()
        configureCircle()
    }
    
    private func configureImage() {
        image.image = UIImage(named: "apple")
    }
    
    private func configureCircle() {
        circle.center = view.center
        circle.backgroundColor = UIColor.lightGray
        circle.layer.borderColor = UIColor.lightGray.cgColor
        circle.layer.cornerRadius = 40.0
        circle.layer.borderWidth = 2.0
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
