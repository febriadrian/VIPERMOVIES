//
//  HomeMoviesInteractor.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class HomeMoviesInteractor: IHomeMoviesPresenterToInteractor {
    var presenter: IHomeMoviesInteractorToPresenter?

    func getMovies(category: MovieCategory, page: Int?) {
        let model = MoviesModel.Request(page: page)
        var endpoint: Endpoint

        switch category {
        case .popular:
            endpoint = .popularMovies(model: model)
        case .playing:
            endpoint = .playingMovies(model: model)
        case .upcoming:
            endpoint = .upcomingMovies(model: model)
        case .toprated:
            endpoint = .topratedMovies(model: model)
        }

        NetworkService.share.request(endpoint: endpoint) { result in
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
