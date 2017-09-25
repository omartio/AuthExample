//
//  FlowController.swift
//  ApplicationCoordinator
//
//

import Foundation

protocol FlowController: NSObjectProtocol {
    
    associatedtype T //enum Actions type
    var completionHandler: ((T) -> ())? {get set}
}

/**
 *  Протокол простого завершения контролера
 */
protocol ControllerFlowOutput {
    
    var onCompletion: (() -> ())? { get set }
}
