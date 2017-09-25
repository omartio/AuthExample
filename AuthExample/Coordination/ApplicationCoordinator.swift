//
//  ApplicationCoordinator.swift
//  Tapl
//
//  Created by Михаил Лукьянов on 31.05.16.
//  Copyright © 2016 Taxac. All rights reserved.
//

import UIKit

class ApplicationCoordinator: BaseCoordinator {
    
    fileprivate(set) var window: UIWindow
    
    
    init(presenter: UIWindow) {
        self.window = presenter
    }
    
    override func start() {
        runStartCoordinator()
    }
    
    func runStartCoordinator() {
        let startCoordinator = StartCoordinator(presenter: WindowPresenter(rootWindow: window))
        startCoordinator.flowCompletionHandler = { [weak self, unowned startCoordinator] _ in
            self?.removeDependancy(startCoordinator)
            
        }
        addDependancy(startCoordinator)
        startCoordinator.start()
        
    }
}
