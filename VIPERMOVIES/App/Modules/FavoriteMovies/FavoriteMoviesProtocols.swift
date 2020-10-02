//
//  FavoriteMoviesProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IFavoriteMoviesViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IFavoriteMoviesPresenterToView? { get set }
    var interactor: IFavoriteMoviesPresenterToInteractor? { get set }
    var router: IFavoriteMoviesPresenterToRouter? { get set }
    var mainViewController: MainViewController? { get }

    func setupParameters()
    func getMovies()
    func navToMovieDetail(id: Int)
}

protocol IFavoriteMoviesInteractorToPresenter: class {
    func presentGetMovies(movies: [MoviesModel.ViewModel])
}

protocol IFavoriteMoviesPresenterToView: class {
    func displayMovies(movies: [MoviesModel.ViewModel])
}

protocol IFavoriteMoviesPresenterToInteractor: class {
    var presenter: IFavoriteMoviesInteractorToPresenter? { get set }

    func getMovies()
    func removeFavorite(at index: Int)
}

protocol IFavoriteMoviesPresenterToRouter: class {
    var view: FavoriteMoviesViewController? { get set }

    func navToMovieDetail(id: Int)
}
