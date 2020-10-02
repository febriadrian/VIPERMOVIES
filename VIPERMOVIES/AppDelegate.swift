//
//  AppDelegate.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.setRootViewController(MainViewController(), options: .init(direction: .fade, style: .easeInOut))

        let navBar = UINavigationBar.appearance()
        navBar.tintColor = Colors.lightBlue
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Colors.darkBlue
        ]
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // do something
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // do something
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // do something
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // do something
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // do something
    }
}
