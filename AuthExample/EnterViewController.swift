//
//  EnterViewController.swift
//  Tapl
//
//  Created by Михаил Лукьянов on 12.04.17.
//  Copyright © 2017 Taxac. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField
import RxGesture

class EnterViewController: UIViewController, ControllerFlowOutput, UIGestureRecognizerDelegate {
    
    let loginField = SkyFloatingLabelTextField()
    let passwordField = SkyFloatingLabelTextField()
    let button = AEButtonFilled()
    
    var onCompletion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.view.layoutIfNeeded()
        
        configureField(field: loginField)
        configureField(field: passwordField)
        view.backgroundColor = UIColor.white
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func initUI() {
        view.backgroundColor = UIColor.white
        
        loginField.placeholder = "Почта"
        loginField.returnKeyType = .next
        loginField.keyboardType = .emailAddress
        loginField.autocapitalizationType = .none
        view.addSubview(loginField)
        
        passwordField.placeholder = "Пароль"
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .go
        view.addSubview(passwordField)
        
        view.addSubview(button)
        
        // Constraints
        
        loginField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(UIScreen.main.bounds.height / 5)
            make.left.equalTo(self.view).offset(25)
            make.right.equalTo(self.view).offset(-25)
            make.height.equalTo(50)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(loginField.snp.bottom).offset(32)
            make.left.equalTo(loginField)
            make.right.equalTo(loginField)
            make.height.equalTo(loginField)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(34)
            make.centerX.equalTo(self.view)
            make.size.equalTo(button.preferredSize)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(gr:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    
    private func configureField(field: SkyFloatingLabelTextField) {

        field.titleFormatter = { return $0.capitalizingFirstLetter() }
        
        field.title = field.placeholder
        field.tintColor = ThemeManager.secondColor
        field.textColor = ThemeManager.foregroundColor
        field.font = ThemeManager.font(size: .large)
        
        field.titleColor = ThemeManager.secondForegroundColor
        field.placeholderColor = ThemeManager.secondForegroundColor
        
        field.lineColor = ThemeManager.disabledColor
        field.selectedTitleColor = ThemeManager.secondColor
        field.selectedLineColor = ThemeManager.secondColor
    }
    
    func closeButtonTapped() {
        onCompletion?()
    }
    
    // MARK: - Gesture
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.view == touch.view!
    }
    
    func tap(gr: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
