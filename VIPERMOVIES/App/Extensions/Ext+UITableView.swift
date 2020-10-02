//
//  Ext+UITableView.swift
//  Cinemov
//
//  Created by Febri Adrian on 14/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCellType<T>(_ cellClass: T.Type) where T: AnyObject {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 80

        let identifier = "\(cellClass)"
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: AnyObject {
        let identifier = "\(cellClass)"
        if let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
            return cell
        }

        fatalError("Error dequeueing cell")
    }
}
