//
//  FavoriteMoviesPresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class FavoriteMoviesPresenter: IFavoriteMoviesViewToPresenter {
    var parameters: [String: Any]?
    var view: IFavoriteMoviesPresenterToView?
    var interactor: IFavoriteMoviesPresenterToInteractor?
    var router: IFavoriteMoviesPresenterToRouter?
    var presenter: IFavoriteMoviesViewToPresenter?
    var mainViewController: MainViewController?

    func setupParameters() {
        mainViewController = parameters?["mainvc"] as? MainViewController
    }

    func getMovies() {
        interactor?.getMovies()
    }

    func navToMovieDetail(id: Int) {
        router?.navToMovieDetail(id: id)
    }
}

extension FavoriteMoviesPresenter: IFavoriteMoviesInteractorToPresenter {
    func presentGetMovies(movies: [MoviesModel.ViewModel]) {
        view?.displayMovies(movies: movies)
    }
}
