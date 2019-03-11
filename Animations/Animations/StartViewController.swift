//
//  StartViewController.swift
//  Animations
//
//  Created by Dmytro Dobrovolskyy on 3/6/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    private let buttonTitles: [String] = ["Animate", "Property Animator", "Dynamic Animation", "Behaviors", "Transitions"]

    @IBOutlet private var collectionOfButtons: [UIButton]!
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var startView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animate(on:)))
            startView.addGestureRecognizer(tapGesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Components configuration
    private func configure() {
        configureStartView()
        configureButtons()
        configureStackView()
    }
    
    private func configureStartView() {
        startView.layer.cornerRadius = startView.frame.height / 2
        startView.layer.masksToBounds = true
    }
    
    private func configureButtons() {
        for (index, button) in collectionOfButtons.enumerated() {
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
            
            button.setTitle(buttonTitles[index], for: .normal)
            button.titleLabel?.textAlignment = .center
        }
    }
    
    private func configureStackView() {
        buttonsStackView.bounds.origin = CGPoint(x: 0, y: (buttonsStackView.frame.height + buttonsStackView.frame.minY + 100))
    }
    
    // MARK: - Animation
    @objc private func animate(on gesture: UIGestureRecognizer) {
        if let tapGesture = gesture as? UITapGestureRecognizer {
            switch tapGesture.state {
            case .changed:
                fallthrough
            case .ended:
                UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                    self.scaling(view: self.startView)
                    self.hide(label: self.startLabel)
                }) { (_) in
                    self.remove(views: [self.startLabel, self.startView])
                    self.view.backgroundColor = #colorLiteral(red: 0.2192930877, green: 0.59985286, blue: 0.8019148111, alpha: 1)
                    self.show(view: self.buttonsStackView)
                    
                    UIView.animate(withDuration: 1, animations: {
                        self.appearance(of: self.buttonsStackView)
                    })
                }
            default:
                break
            }
        }
    }
    
    private func scaling(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 4, y: 4)
    }
    
    private func hide(label: UIView) {
        label.alpha = 0
    }
    
    private func remove(views: [UIView]) {
        views.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func show(view: UIView) {
        view.isHidden = false
    }
    
    private func appearance(of view: UIView) {
        view.alpha = 1
        view.bounds.origin = CGPoint(x: 0, y: 0)
    }
    
}
