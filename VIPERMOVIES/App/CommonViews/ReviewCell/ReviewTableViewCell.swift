//
//  ReviewTableViewCell.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    var handleUpdateCell: (() -> Void)?

    func setupView(review: ReviewModel.ViewModel) {
        authorLabel.text = review.author
        contentLabel.text = review.content
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        subView.layer.cornerRadius = 10
        subView.layer.shadowOffset = .zero
        subView.layer.shadowOpacity = 0.2

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContentLabel))
        contentLabel.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc private func didTapContentLabel() {
        if contentLabel.numberOfLines == 0 {
            contentLabel.numberOfLines = 6
        } else {
            contentLabel.numberOfLines = 0
        }
        handleUpdateCell?()
    }
}
