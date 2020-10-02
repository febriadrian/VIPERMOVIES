//
//  MovieDetailSimilarProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IMovieDetailSimilarViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IMovieDetailSimilarPresenterToView? { get set }
    var interactor: IMovieDetailSimilarPresenterToInteractor? { get set }
    var router: IMovieDetailSimilarPresenterToRouter? { get set }
    var isInitialLoading: Bool { get }

    func setupParameters()
    func getSimilarMovies()
    func updateFavorite()
    func navToMovieDetail(id: Int)
}

protocol IMovieDetailSimilarInteractorToPresenter: class {
    func presentGetMovies(response: MoviesModel.Response)
    func presentGetMoviesError(error: Error?)
    func presentUpdateFavorite(movies: [MoviesModel.ViewModel])
}

protocol IMovieDetailSimilarPresenterToView: class {
    func displayUpdateFavorite(movies: [MoviesModel.ViewModel])
    func displayGetMovies(result: GeneralResult, movies: [MoviesModel.ViewModel])
}

protocol IMovieDetailSimilarPresenterToInteractor: class {
    var presenter: IMovieDetailSimilarInteractorToPresenter? { get set }

    func getSimilarMovies(id: Int)
    func updateFavorite(movies: [MoviesModel.ViewModel])
}

protocol IMovieDetailSimilarPresenterToRouter: class {
    var view: MovieDetailSimilarViewController? { get set }

    func navToMovieDetail(id: Int)
}
