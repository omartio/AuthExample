//
//  AuthCoordinator.swift
//  AuthExample
//
//  Created by Mikhail Lukyanov on 25.09.17.
//  Copyright © 2017 Mikhail Lukyanov. All rights reserved.
//

import Foundation

class AuthCoordinator: BaseCoordinator {
    
    var presenter: Presenter?
    var factory: AuthControllersFactory
    
    init(presenter: Presenter) {
        
        factory = AuthControllersFactory()
        self.presenter = presenter
        
    }
    
    override func start() {
        showLoginController()
    }
    
    func showLoginController() {
        let loginVC = factory.createLoginController()
        loginVC.onCompletion = { [weak self] _ in
            self?.flowCompletionHandler?()
        }
        presenter?.present(loginVC)
    }

}
