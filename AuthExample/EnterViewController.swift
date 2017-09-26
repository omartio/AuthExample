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
import RxKeyboard

class EnterViewController: UIViewController, ControllerFlowOutput, UIGestureRecognizerDelegate {
    
    let loginField = SkyFloatingLabelTextField()
    let passwordField = SkyFloatingLabelTextField()
    let button = AEButtonFilled()
    var centerConstraint: Constraint!
    
    var onCompletion: (() -> ())?
    
    let keyboardDisposeBag = DisposeBag()
    
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
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(44)
            make.top.greaterThanOrEqualToSuperview().offset(5)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(loginField.snp.bottom).offset(18)
            make.left.equalTo(loginField)
            make.right.equalTo(loginField)
            make.height.equalTo(loginField)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(38)
            make.centerX.equalTo(self.view)
            make.size.equalTo(button.preferredSize)
            self.centerConstraint = make.centerY.equalTo(self.view).priority(750).constraint
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(gr:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        RxKeyboard.instance.visibleHeight.skip(1).drive(onNext: {[weak self] (height) in
            // Центр видимой части
            let offset = height / 2
            self?.centerConstraint.update(offset: -offset)
            UIView.animate(withDuration: 0.25, animations: {
                self?.view.layoutIfNeeded()
            })
        }).addDisposableTo(keyboardDisposeBag)
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
        field.errorColor = UIColor.ae.red
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
