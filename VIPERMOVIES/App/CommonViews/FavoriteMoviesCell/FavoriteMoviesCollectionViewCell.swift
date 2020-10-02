//
//  FavoriteMoviesCollectionViewCell.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class FavoriteMoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!

    var handleFavorite: ((_ favorite: Bool) -> Void)?

//    func setupView(movie: FavoriteMoviesModel.ViewModel) {
//        titleLabel.text = movie.title
//        releaseDateLabel.text = movie.releaseDate
//        overviewLabel.text = movie.overview
//        ratingLabel.text = movie.voteAverage
//        favoriteButton.isSelected = movie.favorite
//
//        posterImage.setImage(with: movie.posterUrl, success: {
//            self.posterImage.contentMode = .scaleToFill
//        }) {
//            self.posterImage.contentMode = .center
//            self.posterImage.image = UIImage(named: "tornfilm")
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        subView.layer.cornerRadius = 10
        subView.layer.shadowOffset = .zero
        subView.layer.shadowOpacity = 0.2
        ratingView.layer.cornerRadius = ratingView.frame.height / 2
    }

    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        handleFavorite?(favoriteButton.isSelected)
    }
}
