//
//  StartCoordinator.swift
//  AuthExample
//
//  Created by Mikhail Lukyanov on 25.09.17.
//  Copyright © 2017 Mikhail Lukyanov. All rights reserved.
//

import Foundation
import UIKit

class StartCoordinator: BaseCoordinator {
    
    var presenter: Presenter?
    var factory: StartControllersFactory
    
    init(presenter: Presenter) {
        
        factory = StartControllersFactory()
        self.presenter = presenter
        
    }
    
    override func start() {
        showStartController()
    }
    
    var navController: UINavigationController!
    func showStartController() {
        let vc = factory.createStartController()
        vc.onLogin = { [weak self] _ in
            self?.runAuthCoordinator()
        }
        navController = UINavigationController(rootViewController: vc)
        presenter?.present(navController)
    }
    
    func runAuthCoordinator() {
        let authCoordinator = AuthCoordinator(presenter: NavigationPresenter(rootController: navController))
        authCoordinator.flowCompletionHandler = {[weak self, unowned authCoordinator] _ in
            self?.removeDependancy(authCoordinator)
            self?.flowCompletionHandler?()
        }
        addDependancy(authCoordinator)
        authCoordinator.start()
    }
}
