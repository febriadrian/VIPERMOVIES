//
//  DiscoverMoviesInteractor.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class DiscoverMoviesInteractor: IDiscoverMoviesPresenterToInteractor {
    var presenter: IDiscoverMoviesInteractorToPresenter?

    func getMovies(genreIds: String?, page: Int?) {
        let model = DiscoverMoviesModel.Request(genreIds: genreIds, page: page)
        NetworkService.share.request(endpoint: Endpoint.discover(model: model)) { result in
            switch result {
            case .success(let response):
                let _response = DiscoverMoviesModel.Response(data: response)
                self.presenter?.presentGetMovies(response: _response)
            case .failure(let error):
                self.presenter?.presentGetMoviesError(error: error)
            }
        }
    }
}
