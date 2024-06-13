//
//  HQNavigating.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-10.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

/// Represents something that can navigate.
protocol HQNavigating {
    @discardableResult
    func popToRootViewController(animated: Bool) -> [UIViewController]

    func popToRootViewController(animated: Bool, completion: (() -> Void)?)

    @discardableResult
    func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]
    
    @discardableResult
    func popViewController(animated: Bool) -> UIViewController?
    
    func popViewController(animated: Bool, completion: (() -> Void)?)
    
    func push(_ viewController: UIViewController, animated: Bool, onPop: (() -> Void)?)
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool)
}

extension HQNavigating {

    func push(_ viewController: UIViewController, animated: Bool) {
        push(viewController, animated: animated, onPop: nil)
    }
}

// MARK: - NavigatorDecorating

/// Represents something that describes how to decorate the navigation bar.
protocol HQNavigatorDecorating: AnyObject {
    var hidesNavigationBar: Bool { get }
}

/// Default implementation for `NavigatorDecorating` to make decoration properties optional.
extension HQNavigatorDecorating {
    
    var hidesNavigationBar: Bool { return false }
}

// MARK: - Navigator

/// A proxy object for `UINavigationController`.
final class HQNavigator: NSObject {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
    deinit {
        self.navigationController.delegate = nil
        self.navigationController.setViewControllers([], animated: false)
    }
}

extension HQNavigator: HQNavigating {
    
    func popToRootViewController(animated: Bool) -> [UIViewController] {
        if let poppedControllers = navigationController.popToRootViewController(animated: animated) {
            poppedControllers.forEach { performCompletion(for: $0) }
            return poppedControllers
        }
        return []
    }

    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        _ = popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController] {
        if let poppedControllers = navigationController.popToViewController(viewController, animated: animated) {
            poppedControllers.forEach { performCompletion(for: $0) }
            return poppedControllers
        }
        return []
    }
    
    func popViewController(animated: Bool) -> UIViewController? {
        if let poppedController = navigationController.popViewController(animated: animated) {
            performCompletion(for: poppedController)
            return poppedController
        }
        return nil
    }
    
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        _ = popViewController(animated: animated)
        CATransaction.commit()
    }

    func push(_ viewController: UIViewController, animated: Bool, onPop: (() -> Void)? = nil) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func setRootViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
}

extension HQNavigator: UINavigationControllerDelegate {
    
    // Decorate navigation controller alongside view controller presentation.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let decorator = viewController as? HQNavigatorDecorating {
            navigationController.setNavigationBarHidden(decorator.hidesNavigationBar, animated: animated)
        }
        if let decorator = navigationController as? HQNavigatorDecorating {
            navigationController.setNavigationBarHidden(decorator.hidesNavigationBar, animated: animated)
        }
    }
    
    // Runs completion handler when a user swipes-to-go-back or taps the back button in the navigation bar.
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let poppingViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), // ensure the view controller is popping
            !navigationController.viewControllers.contains(poppingViewController) else {
                return
        }
        
        performCompletion(for: poppingViewController)
    }
}

private extension HQNavigator {
    func performCompletion(for controller: UIViewController) {
        // some completion block here
    }
}
