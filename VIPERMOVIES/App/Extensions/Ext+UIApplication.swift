//
//  Ext+UIApplication.swift
//  Cinemov
//
//  Created by Febri Adrian on 14/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
