//
//  UIColorExtension.swift
//  AuthExample
//
//  Created by Mikhail Lukyanov on 25.09.17.
//  Copyright © 2017 Mikhail Lukyanov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func badgeColor() -> UIColor {
        return UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
    }
    
    class func tabbarColor() -> UIColor {
        return UIColor(red: 249 / 255.0, green: 249 / 255.0, blue: 249 / 255.0, alpha: 1.0)
    }
    
    class var menuBGColor: UIColor {
        return UIColor.white
    }
    
    class var clearWhite: UIColor {
        return UIColor(white: 1, alpha: 0)
    }
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    static var ae: AuthColors {
        return AuthColors()
    }
    
    /**
     Create a ligher color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    /**
     Try to increase brightness or decrease saturation
     */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0,0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
}

class AuthColors {
    
    // Colors from zeplin
    var blue: UIColor {
        return UIColor(red:0.22, green:0.52, blue:0.78, alpha:1.0)
    }
    
    var orange: UIColor {
        return UIColor(red:1.00, green:0.61, blue:0.00, alpha:1.0)
    }
    
    var gray: UIColor {
        return UIColor(red:0.47, green:0.47, blue:0.47, alpha:1.0)
    }
    
    var lightGray: UIColor {
        return UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
    }
    
    var black: UIColor {
        return UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
    }
    
    ///
    
    var green: UIColor {
        return UIColor(red:75/255.0, green:198/255.0, blue:185/255.0,  alpha:1)
    }
    
    var red: UIColor {
        return UIColor(red:255/255.0, green:89/255.0, blue:100/255.0,  alpha:1)
    }
    
}
