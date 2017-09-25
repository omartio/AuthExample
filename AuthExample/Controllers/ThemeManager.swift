//
//  ThemeManager.swift
//  Tapl
//
//  Created by Михаил Лукьянов on 12.04.17.
//  Copyright © 2017 Taxac. All rights reserved.
//

import Foundation
import UIKit

final class ThemeManager {
    
    static let shared = ThemeManager()
    
    var currentTheme: Theme!
    
    init() {
        setTheme(.default)
    }
    
    public func setTheme(_ theme: ThemeList) {
        switch theme {
        case .default:
            setTheme(DefaultTheme())
        }
    }
    
    private func setTheme(_ theme: Theme) {
        currentTheme = theme
        
        UINavigationBar.appearance().tintColor = theme.secondColor
        UINavigationBar.appearance().barTintColor = theme.navBarColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: theme.foregroundColor]
        UITabBar.appearance().tintColor = theme.secondColor
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = theme.darkColor
        }
        UINavigationBar.appearance().isTranslucent = false
        //UINavigationBar.appearance().barStyle = theme.lightContent ? .black : .default
        UITextField.appearance().tintColor = theme.mainColor
    }
    
    func updateAppearance() {
        setTheme(currentTheme)
    }
    
    // Static getters
    
    static var mainColor: UIColor {
        return shared.currentTheme.mainColor
    }
    
    static var secondColor: UIColor {
        return shared.currentTheme.secondColor
    }
    
    static var foregroundColor: UIColor {
        return shared.currentTheme.foregroundColor
    }
    
    static var secondForegroundColor: UIColor {
        return shared.currentTheme.secondForegroundColor
    }
    
    static var disabledColor: UIColor {
        return shared.currentTheme.disabledColor
    }
    
    static var darkColor: UIColor {
        return shared.currentTheme.darkColor
    }
    
    ///  Создает градиент из основных цветов
    ///
    /// - Parameters:
    ///   - direction: напрвеление
    ///   - frame: размер (можно не указывать)
    /// - Returns: слой градиенты
    static func createGradient(direction: GradientDirection,
                               colors: [UIColor] = [shared.currentTheme.mainColor, shared.currentTheme.secondColor],
                               frame: CGRect? = nil) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        if frame != nil {
            gradientLayer.frame = frame!
        }

        switch direction {
        case .vertical: // дефольные значения
            break
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            break
        case .diagonal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .diagonalReverse:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        return gradientLayer
    }
    
    static func font(size: FontSize = .medium, weight: CGFloat = UIFontWeightRegular) -> UIFont {
        return UIFont.systemFont(ofSize: shared.currentTheme.fontSize(forSize: size), weight: weight)
    }
}

enum ThemeList {
    case `default`
}

/// Направление изменение цвета градиента
///
/// - horizontal: по горизонтали
/// - vertical: по вертикали
/// - diagonal: от левого верхнего угла
/// - diagonalReverse: от левого нижнего угла
enum GradientDirection {
    case horizontal
    case vertical
    case diagonal
    case diagonalReverse
}

protocol Theme {
    var mainColor: UIColor { get }
    var secondColor: UIColor { get }
    
    var foregroundColor: UIColor { get }
    var secondForegroundColor: UIColor { get }
    var disabledColor: UIColor { get }
    var darkColor: UIColor { get }
    
    var lightContent: Bool { get }
    var navBarColor: UIColor? { get }
    
    func fontSize(forSize: FontSize) -> CGFloat
}

extension Theme {
    func updateThemeFor(navigationController: UINavigationController? = nil, tabBar: UITabBar? = nil) {
        navigationController?.navigationBar.tintColor = self.foregroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.foregroundColor]
        navigationController?.navigationBar.barTintColor = self.navBarColor
        navigationController?.navigationBar.barStyle = self.lightContent ? .black : .default
        tabBar?.tintColor = self.mainColor
    }
}
struct DefaultTheme: Theme {
    let mainColor = UIColor.ae.orange
    let secondColor = UIColor.ae.blue
    let foregroundColor = UIColor.ae.black
    let secondForegroundColor = UIColor.ae.gray
    let disabledColor = UIColor.ae.lightGray
    let darkColor = UIColor.black
    
    let lightContent = true
    let navBarColor: UIColor? = UIColor.white
    
    func fontSize(forSize size: FontSize) -> CGFloat {
        switch size {
        case .tiny:
            return UIFont.labelFontSize - 5
        case .small:
            return UIFont.labelFontSize - 4
        case .medium:
            return UIFont.labelFontSize - 2
        case .large:
            return UIFont.labelFontSize - 1
        }
    }
}

enum FontType {
    case regular
    case bold
    case light
}

enum FontSize {
    case tiny
    case small
    case medium
    case large
}
