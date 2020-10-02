//
//  Helper.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
    static func arrayToString(_ array: [Any]?) -> String? {
        var string: String?
        if let array = array {
            for x in array {
                if string == nil {
                    string = "\(x)"
                } else {
                    string = string! + ", " + "\(x)"
                }
            }
        }
        return string ?? nil
    }

    static func dateFormatter(_ dateString: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString ?? "") {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let date = dateFormatter.string(from: date)
            return "Release on \(date)"
        }
        return "Release on n/a"
    }

    static func currencyFormatter(price: Int?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: price ?? 0)) ?? "n/a"
    }

    static func updateFavorite(movie: MoviesModel.ViewModel, favorite: Bool, completion: @escaping () -> Void) {
        if favorite {
            let topMostVC = UIApplication.shared.topMostViewController()
            let title = "Remove Favorite"
            let message = "Do You want to remove \(movie.title) from your favorite list?"
            let cancelTitle = "No"
            let submitTitle = "Yes"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
            let submit = UIAlertAction(title: submitTitle, style: .destructive) { _ in
                FavoriteDB.share.remove(id: movie.id)
                let message = "Removed from Favorites list"
                Toast.share.show(message: message)
                completion()
            }

            alert.addAction(cancel)
            alert.addAction(submit)
            topMostVC?.present(alert, animated: true, completion: nil)
        } else {
            FavoriteDB.share.save(movie: movie)
            let message = "Added to Favorites list"
            Toast.share.show(message: message)
            completion()
        }
    }
}
