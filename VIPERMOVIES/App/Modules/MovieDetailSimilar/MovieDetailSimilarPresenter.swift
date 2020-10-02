//
//  MovieDetailSimilarPresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class MovieDetailSimilarPresenter: IMovieDetailSimilarViewToPresenter {
    var parameters: [String: Any]?
    var view: IMovieDetailSimilarPresenterToView?
    var interactor: IMovieDetailSimilarPresenterToInteractor?
    var router: IMovieDetailSimilarPresenterToRouter?
    var presenter: IMovieDetailSimilarViewToPresenter?
    var similarMovies: [MoviesModel.ViewModel] = []
    var isInitialLoading: Bool = true
    var id: Int?

    func setupParameters() {
        id = parameters?["id"] as? Int
    }

    func getSimilarMovies() {
        guard let id = id else { return }
        interactor?.getSimilarMovies(id: id)
    }

    func updateFavorite() {
        interactor?.updateFavorite(movies: similarMovies)
    }
    
    func navToMovieDetail(id: Int) {
        router?.navToMovieDetail(id: id)
    }
}

extension MovieDetailSimilarPresenter: IMovieDetailSimilarInteractorToPresenter {
    func presentGetMovies(response: MoviesModel.Response) {
        guard let results = response.results, results.count > 0 else {
            view?.displayGetMovies(result: .failure(Messages.noMovies), movies: similarMovies)
            return
        }

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

            similarMovies.append(movie)
        }

        isInitialLoading = false
        view?.displayGetMovies(result: .success, movies: similarMovies)
    }

    func presentGetMoviesError(error: Error?) {
        var message = Messages.noInternet
        if error != nil {
            message = Messages.unknownError
        }

        view?.displayGetMovies(result: .failure(message), movies: similarMovies)
    }

    func presentUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        similarMovies = movies
        view?.displayUpdateFavorite(movies: movies)
    }
}
