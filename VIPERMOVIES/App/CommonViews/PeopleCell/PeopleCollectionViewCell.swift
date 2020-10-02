//
//  PeopleCollectionViewCell.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class PeopleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var asLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }

    func setupPersonView(person: MovieDetailModel.PersonModel) {
        nameLabel.text = person.name

        if !person.character.isEmpty {
            asLabel.text = person.character
        } else {
            asLabel.text = person.job
        }

        profileImage.setImage(with: person.profilePath, success: nil) {
            self.profileImage.image = UIImage(named: "defaultProfile")
        }
    }
}
