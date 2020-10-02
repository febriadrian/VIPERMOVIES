//
//  FavoriteMoviesEntity.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

struct FavoriteMoviesModel {
    var createdAt: Int
    var id: Int
    var title: String
    var posterUrl: String
    var voteAverage: String
    var overview: String
    var releaseDate: String

    struct ViewModel {
        private var favoriteMovie: FavoriteObject

        init(favoriteMovie: FavoriteObject) {
            self.favoriteMovie = favoriteMovie
        }

        var createdAt: Int {
            return favoriteMovie.createdAt
        }

        var favorite: Bool {
            return favoriteMovie.favorite
        }

        var id: Int {
            return favoriteMovie.id
        }

        var title: String {
            return favoriteMovie.title
        }

        var posterUrl: String {
            return favoriteMovie.posterUrl
        }

        var voteAverage: String {
            return favoriteMovie.voteAverage
        }

        var overview: String {
            return favoriteMovie.overview
        }

        var releaseDate: String {
            return favoriteMovie.releaseDate
        }
    }
}
