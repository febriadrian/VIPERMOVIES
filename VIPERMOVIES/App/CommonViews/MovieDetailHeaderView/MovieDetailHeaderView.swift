//
//  MovieDetailHeaderView.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailHeaderView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    private let xibName = "MovieDetailHeaderView"

    var contentHeight: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        contentHeight = posterTopConstraint.constant + posterHeightConstraint.constant + posterBottomConstraint.constant
    }
}
