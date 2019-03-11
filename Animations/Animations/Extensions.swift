//
//  Extensions.swift
//  Animations
//
//  Created by Dmytro Dobrovolskyy on 3/7/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

// MARK: - Gesture configuration for view
extension UIView {
    
    func addTapGesture(for target: Any, with action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
    
    func addPanGesture(for target: Any, with action: Selector) {
        let panGesture = UIPanGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(panGesture)
    }
    
}
