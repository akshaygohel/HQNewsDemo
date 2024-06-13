//
//  HQAppCoordinator.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-10.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

class HQAppCoordinator: HQCoordinator {
    // MARK: Properties

    var childCoordinators: [HQCoordinator] = []
    var rootViewController: UIViewController
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
        guard let rootViewController = window.rootViewController else { fatalError("Window must have a rootViewController.") }

        self.rootViewController = rootViewController
        if let initialViewController = rootViewController as? HQInitialViewController {
            initialViewController.delegate = self
        }
    }
}

extension HQAppCoordinator: HQAppLifeCycleEvents {
    
    func applicationDidBecomeActive() {
        
    }
    
    func applicationWillResignActive() {
        
    }
    
    func applicationWillTerminate() {
        
    }
}

// MARK: - Private

private extension HQAppCoordinator {
    func transition(to coordinator: HQCoordinator, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        self.addChild(coordinator)
        
        self.rootViewController = coordinator.rootViewController
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
        UIView.transition(with: self.window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { _ in
            completion?(true)
        }
    }
}

extension HQAppCoordinator: HQInitialViewControllerDelegate {
    func initialScreenLoadDone() {
        let homeCoordinator = HQHomeCoordinator()
        self.transition(to: homeCoordinator, animated: true)
    }
}
