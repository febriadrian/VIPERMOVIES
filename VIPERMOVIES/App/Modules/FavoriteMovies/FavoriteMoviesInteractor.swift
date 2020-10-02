//
//  FavoriteMoviesInteractor.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class FavoriteMoviesInteractor: IFavoriteMoviesPresenterToInteractor {
    var presenter: IFavoriteMoviesInteractorToPresenter?

    func getMovies() {
        let movies = FavoriteDB.share.list()
        presenter?.presentGetMovies(movies: movies)
    }

    func removeFavorite(at index: Int) {
        print("FavoriteMoviesInteractor: \(index)")
    }
}
