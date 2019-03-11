//
//  DynamicAnimationViewController.swift
//  Animations
//
//  Created by Dmytro Dobrovolskyy on 3/6/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class DynamicAnimationViewController: UIViewController {

    @IBOutlet private weak var image: UIImageView!
    
    let ThrowingThreshold: CGFloat = 1000
    let ThrowingVelocityPadding: CGFloat = 35

    private var originalBounds: CGRect = .zero
    private var originalCenter: CGPoint = .zero
    
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
    @objc private func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.image)
        
        switch sender.state {
        case .began:
            // 1
            animator.removeAllBehaviors()
            
            // 2
            let centerOffset = UIOffset(horizontal: boxLocation.x - image.bounds.midX,
                                        vertical: boxLocation.y - image.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: image,
                                                      offsetFromCenter: centerOffset, attachedToAnchor: location)
            
            // 4
            animator.addBehavior(attachmentBehavior)
            
        case .ended:
//            resetDemo()
            animator.removeAllBehaviors()
            
            // 1
            let velocity = sender.velocity(in: view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            
            if magnitude > ThrowingThreshold {
                // 2
                let pushBehavior = UIPushBehavior(items: [image], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding
                
                self.pushBehavior = pushBehavior
                animator.addBehavior(pushBehavior)
                
                // 3
                let angle = Int(arc4random_uniform(20)) - 10
                
                itemBehavior = UIDynamicItemBehavior(items: [image])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), for: image)
                animator.addBehavior(itemBehavior)
                
                // 4
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.resetDemo()
                }
            } else {
                resetDemo()
            }
            
        default:
            attachmentBehavior.anchorPoint = sender.location(in: view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addPanGesture(for: self, with: #selector(handleAttachmentGesture(sender:)))
        
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = image.bounds
        originalCenter = image.center
    }
    
    func resetDemo() {
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.image.bounds = self.originalBounds
            self.image.center = self.originalCenter
//            self.image.transform = CGAffineTransform
        })
    }
    
}
