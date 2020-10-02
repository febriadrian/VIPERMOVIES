//
//  DiscoverMoviesProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IDiscoverMoviesViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IDiscoverMoviesPresenterToView? { get set }
    var interactor: IDiscoverMoviesPresenterToInteractor? { get set }
    var router: IDiscoverMoviesPresenterToRouter? { get set }
    var mainViewController: MainViewController? { get }
    var totalResults: Int { get }
    var isInitialLoading: Bool { get }
    var isLoadingMore: Bool { get }
    var genreIds: [String]? { get set }
    var selectedIndex: [IndexPath]? { get set }

    func setupParameters()
    func getMovies()
    func startLoadMore()
    func startRefreshing()
    func navToMovieDetail(id: Int)
    func navToGenres()
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?)
}

protocol IDiscoverMoviesInteractorToPresenter: class {
    func presentGetMovies(response: DiscoverMoviesModel.Response)
    func presentGetMoviesError(error: Error?)
}

protocol IDiscoverMoviesPresenterToView: class {
    func displayGetMovies(result: MoviesResult, movies: [MoviesModel.ViewModel])
}

protocol IDiscoverMoviesPresenterToInteractor: class {
    var presenter: IDiscoverMoviesInteractorToPresenter? { get set }

    func getMovies(genreIds: String?, page: Int?)
}

protocol IDiscoverMoviesPresenterToRouter: class {
    var view: DiscoverMoviesViewController? { get set }

    func navToMovieDetail(id: Int)
    func navToGenres(selectedIndex: [IndexPath]?)
}
