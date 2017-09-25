//
//  Presenter.swift
//  ApplicationCoordinator
//
import UIKit

protocol Presenter: class {
    
    func present(_ viewController: UIViewController)
    func dismissController(_ animated: Bool)
}

class ModalPresenter: Presenter {
    
    weak var rootController: UIViewController?
    
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    func present(_ controller: UIViewController) {
        rootController?.present(controller, animated: true, completion: nil)
    }

    func dismissController(_ animated: Bool = true) {
        rootController?.dismiss(animated: animated, completion: nil)
    }
}


class NavigationPresenter: Presenter {
    
    typealias ViewController = UINavigationController
    weak var rootController: ViewController?
    
    init(rootController: ViewController) {
        self.rootController = rootController
    }
    
    func present(_ controller: UIViewController) {
        rootController?.pushViewController(controller, animated: true)
    }
    
//    func push(_ controller: UIViewController, animated: Bool = true)  {
//        
//    }
    
//    func popController(_ animated: Bool = true)  {
//        
//    }
    
    func dismissController(_ animated: Bool = true) {
        rootController?.popViewController(animated: animated)
    }
}

class WindowPresenter: Presenter {
    
    weak var rootWindow: UIWindow?
    
    init(rootWindow: UIWindow) {
        self.rootWindow = rootWindow
    }
    
    func present(_ controller: UIViewController) {
        rootWindow?.rootViewController = controller
        rootWindow?.makeKeyAndVisible()
    }
    
    func dismissController(_ animated: Bool) {
        
    }
}
