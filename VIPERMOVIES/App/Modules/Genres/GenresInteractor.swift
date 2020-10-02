//
//  GenresInteractor.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class GenresInteractor: IGenresPresenterToInteractor {
    var presenter: IGenresInteractorToPresenter?

    func getGenres() {
        let model = GenresModel.Request()
        NetworkService.share.request(endpoint: Endpoint.genres(model: model)) { result in
            switch result {
            case .success(let response):
                let _response = GenresModel.Response(data: response)
                self.presenter?.presentGetGenres(response: _response)
            case .failure(let error):
                self.presenter?.presentGetGenresError(error: error)
            }
        }
    }
}
