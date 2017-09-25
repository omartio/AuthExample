//
//  StartViewController.swift
//  AuthExample
//
//  Created by Mikhail Lukyanov on 25.09.17.
//  Copyright © 2017 Mikhail Lukyanov. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, StartViewControllerOutput {

    // MARK: - Views
    let loginButton = AEButtonFilled()
    
    // MARK: - Out
    var onLogin: (() -> ())?
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iniUI()
        initConstraints()
        bindUI()
    }

    func iniUI() {
        view.backgroundColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        loginButton.setTitle("Авторизация", for: .normal)
        view.addSubview(loginButton)
        
        // hide nav bar shadow
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func initConstraints() {
        loginButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(loginButton.preferredSize)
        }
    }
    
    func bindUI() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    func loginButtonTapped() {
        onLogin?()
    }
}

protocol StartViewControllerOutput {
    var onLogin: (() -> ())? { get set }
}
