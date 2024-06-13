//
//  HQAppDelegate.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-10.
//

import UIKit

@main
class HQAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: HQAppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.startAppCoordinator()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        appCoordinator?.applicationWillResignActive()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appCoordinator?.applicationDidBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        appCoordinator?.applicationWillTerminate()
    }

}

extension HQAppDelegate {
    private func startAppCoordinator() {
        guard let window = window else { fatalError("No window") }
        
        self.appCoordinator = HQAppCoordinator(window: window)
//        self.appCoordinator?.delegate = self
    }
}
