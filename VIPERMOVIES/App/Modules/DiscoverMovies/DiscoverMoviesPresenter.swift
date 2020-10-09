//
//  DiscoverMoviesPresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class DiscoverMoviesPresenter: IDiscoverMoviesViewToPresenter {
    var parameters: [String: Any]?
    var view: IDiscoverMoviesPresenterToView?
    var interactor: IDiscoverMoviesPresenterToInteractor?
    var router: IDiscoverMoviesPresenterToRouter?
    var presenter: IDiscoverMoviesViewToPresenter?

    var mainViewController: MainViewController?
    var movies: [MoviesModel.ViewModel] = []
    var page: Int = 1
    var totalResults: Int = 100
    var isInitialLoading: Bool = true
    var isRefreshing: Bool = false
    var isLoadingMore: Bool = false
    var genreIds: [String]?
    var selectedIndex: [IndexPath]?
    var selectedIds: String?
    var resultsCount: Int?

    func setupParameters() {
        mainViewController = parameters?["mainvc"] as? MainViewController
    }

    func getMovies() {
        interactor?.getMovies(genreIds: selectedIds, page: page)
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

    func navToMovieDetail(id: Int) {
        router?.navToMovieDetail(id: id)
    }

    func navToGenres() {
        router?.navToGenres(selectedIndex: selectedIndex)
    }

    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?) {
        self.genreIds = genreIds
        self.selectedIndex = selectedIndex

        if let genreIds = genreIds {
            selectedIds = Helper.arrayToString(genreIds)
        } else {
            selectedIds = nil
        }

        page = 1
        totalResults = 100
        isInitialLoading = true
        getMovies()
    }
}

extension DiscoverMoviesPresenter: IDiscoverMoviesInteractorToPresenter {
    func presentGetMovies(response: DiscoverMoviesModel.Response) {
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
}
