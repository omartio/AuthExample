//
//  Coordinator.swift
//  ApplicationCoordinator
//
//

import Foundation

typealias CoordinatorHandler = () -> ()

protocol Coordinator: class {
    
    var flowCompletionHandler: CoordinatorHandler? {get set}
    func start()
}