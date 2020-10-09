//
//  HomeMoviesPresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class HomeMoviesPresenter: IHomeMoviesViewToPresenter {
    var parameters: [String: Any]?
    var view: IHomeMoviesPresenterToView?
    var interactor: IHomeMoviesPresenterToInteractor?
    var router: IHomeMoviesPresenterToRouter?
    var presenter: IHomeMoviesViewToPresenter?

    var homeViewController: HomeViewController?
    var category: MovieCategory?
    var page: Int = 1
    var totalResults: Int = 100
    var isInitialLoading: Bool = true
    var isRefreshing: Bool = false
    var isLoadingMore: Bool = false
    var movies: [MoviesModel.ViewModel] = []
    var resultsCount: Int?

    func setupParameters() {
        homeViewController = parameters?["homevc"] as? HomeViewController
        category = parameters?["category"] as? MovieCategory
    }

    func getMovies() {
        guard let category = category else { return }
        interactor?.getMovies(category: category, page: page)
    }

    func startLoadMore() {
        isLoadingMore = true
        page += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.getMovies()
        }
    }

    func startRefreshing() {
        isRefreshing = true
        page = 1
        totalResults = 100
        getMovies()
    }

    func updateFavorite() {
        interactor?.updateFavorite(movies: movies)
    }

    func navToMovieDetail(id: Int) {
        router?.navToMovieDetail(id: id)
    }
}

extension HomeMoviesPresenter: IHomeMoviesInteractorToPresenter {
    func presentGetMovies(response: MoviesModel.Response) {
        page = response.page ?? page
        totalResults = response.totalResults ?? totalResults

        guard let results = response.results, results.count > 0 else {
            resultsCount = 0
            presentGetMoviesError(error: nil)
            return
        }

        var result: MoviesResult = .successInitialLoading
        var newMovies: [MoviesModel.ViewModel] = []

        for x in results {
            var voteAverage: String?
            let path = x.posterPath ?? ""
            if let rating = x.voteAverage, rating != 0 {
                voteAverage = "\(rating)"
            }

            let movie = MoviesModel.ViewModel(
                id: x.id ?? 0,
                title: x.title ?? "title is not available",
                posterUrl: ImageUrl.poster + path,
                voteAverage: voteAverage ?? "n/a",
                overview: x.overview ?? "overview is not available",
                releaseDate: Helper.dateFormatter(x.releaseDate),
                favorite: FavoriteDB.share.checkIsFavorite(id: x.id ?? 0),
                createdAt: 0
            )

            newMovies.append(movie)
        }

        if isLoadingMore {
            var indexPaths: [IndexPath] = []

            for x in 0..<newMovies.count {
                let indexPath: IndexPath = [0, self.movies.count + x]
                indexPaths.append(indexPath)
            }

            isLoadingMore = false
            movies += newMovies
            result = .successLoadMore(indexPaths)
        } else {
            movies = newMovies

            if isRefreshing {
                isRefreshing = false
                result = .successRefreshing
            } else {
                isInitialLoading = false
                result = .successInitialLoading
            }
        }

        view?.displayGetMovies(result: result, movies: movies)
    }

    func presentGetMoviesError(error: Error?) {
        var message = Messages.noInternet
        var result: MoviesResult = .failureInitialLoading(message)

        if error != nil {
            message = Messages.unknownError
        } else if resultsCount == 0 {
            message = Messages.noMovies
            resultsCount = nil
        }

        if isLoadingMore {
            isLoadingMore = false
            page -= 1
            let indexPath = IndexPath(item: movies.count - 1, section: 0)
            result = .failureLoadMore(message, indexPath)
        } else if isRefreshing {
            isRefreshing = false
            result = .failureRefreshing(message)
        } else {
            isInitialLoading = false
            result = .failureInitialLoading(message)
        }

        view?.displayGetMovies(result: result, movies: movies)
    }

    func presentUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        self.movies = movies
        view?.displayUpdateFavorite(movies: movies)
    }
}
