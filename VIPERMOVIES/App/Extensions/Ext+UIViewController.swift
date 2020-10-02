//
//  Ext+UIViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 14/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }

        return self
    }
}
