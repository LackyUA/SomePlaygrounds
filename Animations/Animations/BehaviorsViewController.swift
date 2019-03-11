//
//  BehaviorsViewController.swift
//  Animations
//
//  Created by Dmytro Dobrovolskyy on 3/6/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class BehaviorsViewController: UIViewController {

    // Add box
    var box : UIView?
    
    var maxX : CGFloat = 320
    var maxY : CGFloat = 320
    let boxSize : CGFloat = 30.0
    var boxes : Array<UIView> = []
    
    // UIGravityBehavior
    var animator: UIDynamicAnimator?
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    let itemBehavior = UIDynamicItemBehavior()
    
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView: self.view);
        animator?.addBehavior(collider)
        
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
        animator?.addBehavior(gravity);
        
        // we're bouncin' off the walls
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        itemBehavior.friction = 0.1
        itemBehavior.elasticity = 1
        itemBehavior.resistance = 0.1
        itemBehavior.allowsRotation = false
        animator?.addBehavior(itemBehavior)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maxX = super.view.bounds.size.width - boxSize
        maxY = super.view.bounds.size.height - boxSize
        
        createAnimatorStuff()
        generateBoxes()
    }
    
    private func randomColor() -> UIColor {
        let red = CGFloat(CGFloat(arc4random()%100000)/100000)
        let green = CGFloat(CGFloat(arc4random()%100000)/100000)
        let blue = CGFloat(CGFloat(arc4random()%100000)/100000)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func doesNotCollide(testRect: CGRect) -> Bool {
        for box : UIView in boxes {
            let viewRect = box.frame;
            if(testRect.intersects(viewRect)) {
                return false
            }
        }
        return true
    }
    
    func randomFrame() -> CGRect {
        var guess = CGRect(x: 9, y: 9, width: 9, height: 9)
        
        repeat {
            let guessX = CGFloat(arc4random()).truncatingRemainder(dividingBy: maxX)
            let guessY = CGFloat(arc4random()).truncatingRemainder(dividingBy: maxY)
            guess = CGRect(x: guessX, y: guessY, width: boxSize, height: boxSize)
        } while(!doesNotCollide(testRect: guess))
        
        return guess
    }
    
    func addBox(location: CGRect, color: UIColor) {
        let newBox = UIView(frame: location)
        newBox.backgroundColor = color
        
        view.addSubview(newBox)
        addBoxToBehaviors(box: newBox)
        boxes.append(newBox)
    }
    
    func generateBoxes() {
        for _ in 0...10 {
            let frame = randomFrame()
            let color = randomColor()
            addBox(location: frame, color: color)
        }
    }
    
    func addBoxToBehaviors(box: UIView) {
        gravity.addItem(box)
        collider.addItem(box)
        itemBehavior.addItem(box)
    }
    
}
