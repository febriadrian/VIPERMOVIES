//
//  Ext+UIImageView.swift
//  Cinemov
//
//  Created by Febri Adrian on 14/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(with urlString: String, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        let imgUrl = URL(string: urlString)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: imgUrl, placeholder: nil, options: [.transition(.fade(0.3))]) { result in
            switch result {
            case .success:
                success?()
            case .failure:
                failure?()
            }
        }
    }
}
