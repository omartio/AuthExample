//
//  UIViewExtension.swift
//  AuthExample
//
//  Created by Mikhail Lukyanov on 25.09.17.
//  Copyright © 2017 Mikhail Lukyanov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: - Borders
    
    func makeCircleBorder(_ width: Float = 0, color: UIColor = UIColor.clear) {
        
        let radius = min(Float(self.frame.size.height / 2.0), Float(self.frame.size.width / 2.0))
        
        makeRoundBorder(radius, width: width, color: color)
    }
    
    func makeRoundBorder(_ radius: Float, width: Float = 0, color: UIColor = UIColor.clear){
        
        let layer = self.layer
        layer.masksToBounds = true
        layer.borderWidth = CGFloat(width)
        layer.borderColor = color.cgColor
        layer.cornerRadius = CGFloat(radius)
    }
    
    func addLineAtBottom(width: CGFloat, color: UIColor, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 0 + insets.left, y: self.frame.size.height - width, width: self.frame.size.width - (insets.left + insets.right), height: width)
        lineLayer.backgroundColor = color.cgColor
        self.layer.addSublayer(lineLayer)
    }
    
    //MARK: - Nib

    class func nib() -> UINib? {
        return UINib(nibName: nameOfClass, bundle: Bundle.main)
    }
}

extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(_ corners: UIRectCorner, radius: CGFloat) {
        _round(corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners, radius: radius)
        addBorder(mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(_ diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

private extension UIView {
    
    func _round(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(_ mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}

//MARK: Shadows
extension UIView {
    func addShadow(radius: CGFloat = 10) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
    }
    
    ///  Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    public func tm_addShadow(ofColor color: UIColor = UIColor.darkGray,
                          radius: CGFloat = 3,
                          offset: CGSize = CGSize(width: 3, height: 3),
                          opacity: Float = 0.3) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    
    func applyHoverShadow(color: UIColor = UIColor.black) {
        let size = self.bounds.size
        let width = size.width
        let height = size.height
        
        let ovalRect = CGRect(x: 20, y: height - 12, width: width - 40, height: 16)
        let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
        
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowPath = path.cgPath
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.65
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
}

extension UIScrollView {
    
    var isScrolledToBottom: Bool {
        let tableHeight = self.bounds.size.height
        let contentHeight = self.contentSize.height
        let insetHeight = self.contentInset.bottom
        
        let yOffset = self.contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
        
        return yOffsetAtBottom > contentHeight
    }
}

//MARK: Animations

extension UIView {
    
    func setHiddenWithZoom(isHidden: Bool, duration: TimeInterval = 0.2)  {
        guard self.isHidden != isHidden else {
            return
        }
        
        self.layer.removeAllAnimations()
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if isHidden {
            UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState], animations: {
                self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
                self.alpha = 0
            }, completion: { (finished) in
                if finished {
                    self.isHidden = true
                    self.alpha = 1
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }
            })
        } else {
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
            self.alpha = 0
            self.isHidden = false
            
            UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState], animations: {
                self.alpha = 1
                self.layer.setAffineTransform(CGAffineTransform.identity)
            }, completion: { (finished) in
                if finished {
                    self.alpha = 1
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }
            })
        }
    }
    
    func animateAlpha(_ alpha: CGFloat, duration: TimeInterval = 0.2) {
        guard self.alpha != alpha else {
            return
        }
        
        UIView.animate(withDuration: duration) { 
            self.alpha = alpha
        }
    }
}
