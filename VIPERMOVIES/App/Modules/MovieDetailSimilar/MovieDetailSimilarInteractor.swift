//
//  MovieDetailSimilarInteractor.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class MovieDetailSimilarInteractor: IMovieDetailSimilarPresenterToInteractor {
    var presenter: IMovieDetailSimilarInteractorToPresenter?

    func getSimilarMovies(id: Int) {
        let model = SimilarMoviesModel.Request(id: id)
        NetworkService.share.request(endpoint: Endpoint.movieSimilar(model: model)) { result in
            switch result {
            case .success(let response):
                let _response = MoviesModel.Response(data: response)
                self.presenter?.presentGetMovies(response: _response)
            case .failure(let error):
                self.presenter?.presentGetMoviesError(error: error)
            }
        }
    }

    func updateFavorite(movies: [MoviesModel.ViewModel]) {
        var movies = movies
        for x in 0..<movies.count {
            movies[x].favorite = FavoriteDB.share.checkIsFavorite(id: movies[x].id)
        }

        presenter?.presentUpdateFavorite(movies: movies)
    }
}
