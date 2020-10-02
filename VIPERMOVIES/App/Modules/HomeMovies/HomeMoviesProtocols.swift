//
//  HomeMoviesProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IHomeMoviesViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IHomeMoviesPresenterToView? { get set }
    var interactor: IHomeMoviesPresenterToInteractor? { get set }
    var router: IHomeMoviesPresenterToRouter? { get set }
    var homeViewController: HomeViewController? { get }
    var totalResults: Int { get }
    var isInitialLoading: Bool { get }
    var isLoadingMore: Bool { get }

    func setupParameters()
    func getMovies()
    func startLoadMore()
    func startRefreshing()
    func updateFavorite()
    func navToMovieDetail(id: Int)
}

protocol IHomeMoviesInteractorToPresenter: class {
    func presentGetMovies(response: MoviesModel.Response)
    func presentGetMoviesError(error: Error?)
    func presentUpdateFavorite(movies: [MoviesModel.ViewModel])
}

protocol IHomeMoviesPresenterToView: class {
    func displayGetMovies(result: MoviesResult, movies: [MoviesModel.ViewModel])
    func displayUpdateFavorite(movies: [MoviesModel.ViewModel])
}

protocol IHomeMoviesPresenterToInteractor: class {
    var presenter: IHomeMoviesInteractorToPresenter? { get set }

    func getMovies(category: MovieCategory, page: Int?)
    func updateFavorite(movies: [MoviesModel.ViewModel])
}

protocol IHomeMoviesPresenterToRouter: class {
    var view: HomeMoviesViewController? { get set }

    func navToMovieDetail(id: Int)
}
