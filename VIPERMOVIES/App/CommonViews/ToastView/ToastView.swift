//
//  ToastView.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class ToastView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    private let xibName = "ToastView"

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
    }
}
