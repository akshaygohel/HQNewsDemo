//
//  HQCoordinator.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-10.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

// MARK: - Coordinator

/// Represents something capable of controlling the flow of view controllers.
protocol HQCoordinator: AnyObject {
    var rootViewController: UIViewController { get }
    var childCoordinators: [HQCoordinator] { get set }
}

extension HQCoordinator {
     
    func addChild(_ child: HQCoordinator) {
        childCoordinators.append(child)
    }
    
    func removeChild(_ child: HQCoordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}

// MARK: - HQPresentingCoordinator

/// Handles presenting and dismissing a `HQCoordinator`.
protocol HQPresentingCoordinator: HQCoordinator {
    func present(_ coordinatorToPresent: HQCoordinator, animated: Bool, completion: (() -> Void)?)
    func dismiss(_ coordinaor: HQCoordinator, animated: Bool, completion: (() -> Void)?)
}

extension HQPresentingCoordinator {
    
    func present(_ coordinatorToPresent: HQCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        addChild(coordinatorToPresent)
        rootViewController.present(coordinatorToPresent.rootViewController, animated: animated, completion: completion)
    }
    
    func dismiss(_ coordinaor: HQCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        coordinaor.rootViewController.dismiss(animated: animated, completion: completion)
        removeChild(coordinaor)
    }
}

// MARK: - HQNavigatingCoordinator

/// Handles the navigation flow of one or more `HQCoordinator`s.
protocol HQNavigatingCoordinator: HQCoordinator {
    var navigator: HQNavigating { get }
}

extension HQNavigatingCoordinator {
    
    func pushCoordinator(_ coordinator: HQCoordinator, animated: Bool = true) {
        addChild(coordinator)
        navigator.push(coordinator.rootViewController, animated: animated) {
            self.removeChild(coordinator)
        }
    }
}

protocol HQAppLifeCycleEvents: AnyObject {
    func applicationDidBecomeActive()
    func applicationWillTerminate()
}
