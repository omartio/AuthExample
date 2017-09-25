//
//  LoginViewController.swift
//  Tapl
//
//  Created by Михаил Лукьянов on 03.06.16.
//  Copyright © 2016 Taxac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: EnterViewController, LoginViewControllerOutput {

	var viewModel = LoginViewModel()
	let disposeBug = DisposeBag()

    var onSingUp: (() -> ())?
    var onRecovery: ((String?) -> ())?

    let signupButton = UIButton()
    let recoveryButton = UIButton()
    
	override func viewDidLoad() {
		super.viewDidLoad()

        initConstraints()
		bindView()
        
        view.layoutIfNeeded()
        custumizeLayers()
	}
    
	override func initUI() {
		super.initUI()
        title = "Авторизаця"

        button.setTitle("Войти", for: .normal)
        
        signupButton.setTitle("У мня еще нет аккаунта. Создать.", for: .normal)
        signupButton.setTitleColorWithHighlight(color: ThemeManager.secondColor)
        signupButton.titleLabel?.font = ThemeManager.font()
        view.addSubview(signupButton)
        
        recoveryButton.setTitle("Забыли пароль?", for: .normal)
        recoveryButton.setTitleColorWithHighlight(color: ThemeManager.secondForegroundColor)
        recoveryButton.titleLabel?.font = ThemeManager.font(size: .tiny)
        recoveryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(recoveryButton)
	}

    func custumizeLayers() {
        recoveryButton.makeRoundBorder(4, width: 0.5, color: ThemeManager.disabledColor)
    }
    
    func initConstraints() {
        recoveryButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(passwordField)
            make.trailing.equalTo(passwordField.snp.trailing)
            make.height.equalTo(30)
        }
        
        signupButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(button.snp.bottom).offset(21)
        }
    }
    
	func bindView() {
		_ = loginField.rx.text.orEmpty.bind(to: viewModel.userNameObservable)
		_ = passwordField.rx.text.orEmpty.bind(to: viewModel.passwordObservable)

		_ = loginField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
			self?.passwordField.becomeFirstResponder()
		}).addDisposableTo(disposeBug)
        
        passwordField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            if !(self?.loginField.text?.isEmpty ?? true) {
                self?.login()
            }
        }).addDisposableTo(disposeBug)
        
        
        
        signupButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        recoveryButton.addTarget(self, action: #selector(recoveryButtonTapped), for: .touchUpInside)
	}
    
    // MARK: - Actions

    func login() {
        self.view.endEditing(true)

    }
    
    func signUpButtonTapped() {
        onSingUp?()
    }
    
    func recoveryButtonTapped() {
        onRecovery?(loginField.text)
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

protocol LoginViewControllerOutput {
    var onRecovery: ((String?) -> ())? { get set }
    var onSingUp: (() -> ())? { get set }
}
