//
//  Ext+UIButton.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 09/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

extension UIButton {
    func touchUpInside(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
}
