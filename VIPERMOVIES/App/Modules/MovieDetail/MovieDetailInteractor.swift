//
//  MovieDetailInteractor.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class MovieDetailInteractor: IMovieDetailPresenterToInteractor {
    var presenter: IMovieDetailInteractorToPresenter?
    //

    func getMovieDetail(id: Int) {
        let model = MovieDetailModel.Request(id: id)
        NetworkService.share.request(endpoint: Endpoint.movieDetail(model: model)) { result in
            switch result {
            case .success(let response):
                let _response = MovieDetailModel.Response(data: response)
                self.presenter?.presentGetMovieDetail(response: _response)
            case .failure(let error):
                self.presenter?.presentGetMovieDetail(error: error)
            }
        }
    }
    
    func updateFavorite(movie: MoviesModel.ViewModel, favorite: Bool) {
        Helper.updateFavorite(movie: movie, favorite: favorite) {
            self.presenter?.presentUpdateFavorite()
        }
    }
}
