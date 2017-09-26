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

    var viewModel: LoginViewModel
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	let disposeBug = DisposeBag()

    var onSingUp: (() -> ())?
    var onRecovery: ((String?) -> ())?

    let signupButton = UIButton()
    let recoveryButton = UIButton()
    let wrongPasswordLabel = UILabel()
    
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

        passwordField.titleLabel.numberOfLines = 0
        
        signupButton.setTitle("У мня еще нет аккаунта. Создать.", for: .normal)
        signupButton.setTitleColorWithHighlight(color: ThemeManager.secondColor)
        signupButton.titleLabel?.font = ThemeManager.font()
        view.addSubview(signupButton)
        
        recoveryButton.setTitle("Забыли пароль?", for: .normal)
        recoveryButton.setTitleColorWithHighlight(color: ThemeManager.secondForegroundColor)
        recoveryButton.titleLabel?.font = ThemeManager.font(size: .tiny)
        recoveryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(recoveryButton)
        
        wrongPasswordLabel.text = "Минимум 6 символов, должен обязательно содержать минимум 1 строчную букву, 1 заглавную, и 1 цифру"
        wrongPasswordLabel.textColor = UIColor.ae.red
        wrongPasswordLabel.font = ThemeManager.font(size: .tiny)
        wrongPasswordLabel.numberOfLines = 0
        wrongPasswordLabel.isHidden = true
        view.addSubview(wrongPasswordLabel)
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
        wrongPasswordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(4)
            make.leading.equalTo(passwordField)
            make.trailing.equalTo(passwordField)
        }
    }
    
	func bindView() {
		_ = loginField.rx.text.orEmpty.bind(to: viewModel.userNameObservable)
		_ = passwordField.rx.text.orEmpty.bind(to: viewModel.passwordObservable)

        // Переход на поле пароля по кнопку next
		_ = loginField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
			self?.passwordField.becomeFirstResponder()
		}).addDisposableTo(disposeBug)
        
        // Логин по кнопки на клавиатура
        passwordField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            if !(self?.loginField.text?.isEmpty ?? true) {
                self?.login()
            }
        }).addDisposableTo(disposeBug)
        
        // Проверка почты при выходе из поля
        _ = loginField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            _ = self?.validateEmail()
        }).addDisposableTo(disposeBug)
        
        // Проверка пароля при выходи из поля
        passwordField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            _ = self?.validatePassword()
        }).addDisposableTo(disposeBug)
        
        // Проверка почты на исправление
        loginField.rx.text.orEmpty.subscribe(onNext: { [weak self] (text) in
            if self?.loginField.errorMessage != nil {
                _ = self?.validateEmail()
            }
        }).addDisposableTo(disposeBug)
        
        // Проверка пароля на исправление
        passwordField.rx.text.orEmpty.subscribe(onNext: { [weak self] (text) in
            if self?.passwordField.errorMessage != nil {
                _ = self?.validatePassword()
            }
        }).addDisposableTo(disposeBug)
        
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        recoveryButton.addTarget(self, action: #selector(recoveryButtonTapped), for: .touchUpInside)
	}
    
    // MARK: - Actions
    
    func validateEmail() -> Bool {
        guard let email = loginField.text, email.characters.count > 0 else { return true }
        if email.isValidEmail {
            loginField.errorMessage = nil
            return true
        } else {
            loginField.errorMessage = "Неверный e-mail"
            return false
        }
    }
    
    func validatePassword() -> Bool {
        guard let password = passwordField.text, password.characters.count > 0 else { return true }
        if password.isValidPassword {
            passwordField.errorMessage = nil
            wrongPasswordLabel.isHidden = true
            return true
        } else {
            passwordField.errorMessage = "Неверный пароль"
            wrongPasswordLabel.isHidden = false
            return false
        }
    }

    func login() {
        self.view.endEditing(true)
        
        guard validateEmail() && validatePassword() else {
            return
        }
        
        viewModel.login { (response) in
            if response != nil {
                let alertController = UIAlertController(title: "Погода", message: response, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Закрыть", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
