//
//  BaseCoordinator.swift
//  ApplicationCoordinator
//
//
import Foundation
import UIKit

class BaseCoordinator: NSObject, Coordinator {
    
    var flowCompletionHandler:CoordinatorHandler?
    var childCoordinators: [Coordinator] = []

    func start() {
        fatalError("must be overriden")
    }
    
    func addDependancy(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeDependancy(_ coordinator: Coordinator) {
        guard childCoordinators.isEmpty == false else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if ObjectIdentifier(element) == ObjectIdentifier(coordinator) {
                childCoordinators.remove(at: index)
            }
        }
    }
    
    /**
     Самый последний в стаке координатор
     */
    func topCoordinator() -> BaseCoordinator {
        
        var topCoordinator = self
        while topCoordinator.childCoordinators.last != nil {
            topCoordinator = topCoordinator.childCoordinators.last as! BaseCoordinator
        }
        return topCoordinator
    }
}
