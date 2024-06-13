//
//  HQHomeCoordinator.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

extension UIStoryboard.Identifier {
    static let home = UIStoryboard.Identifier(name: "HQHome")
}

class HQHomeCoordinator: HQNavigatingCoordinator, HQPresentingCoordinator {
    // MARK: Properties
    var navigator: HQNavigating

    var childCoordinators: [HQCoordinator] = []
    var rootViewController: UIViewController

    private var homeViewController: HQHomeViewController
    
    init() {
        self.homeViewController = UIStoryboard(identifier: .home).instantiateViewController()
        // Configure navigationController
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigator = HQNavigator(navigationController: navigationController)
        self.rootViewController = navigationController
        self.homeViewController.navigationDelegate = self
    }
}

// MARK: - Private

extension HQHomeCoordinator: HQHomeViewControllerNavigationDelegate {
    func homeNavigateTo(link: String, withTitle title: String? = nil) {
        self.navigateToWeb(with: link, withTitle: title)
    }
    
    private func navigateToWeb(with urlString: String, withTitle title: String? = nil) {
        if let webBrowserViewController = UIStoryboard(identifier: .home).instantiateViewController(withIdentifier: "HQWebBrowserViewController") as? HQWebBrowserViewController {
            webBrowserViewController.navigationTitle = title
            webBrowserViewController.urlString = urlString
            self.navigator.push(webBrowserViewController, animated: true)
        }
    }
}
