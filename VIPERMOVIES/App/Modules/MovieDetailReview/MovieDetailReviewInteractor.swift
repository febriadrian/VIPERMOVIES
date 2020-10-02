//
//  MovieDetailReviewInteractor.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class MovieDetailReviewInteractor: IMovieDetailReviewPresenterToInteractor {
    var presenter: IMovieDetailReviewInteractorToPresenter?

    func getReviews(id: Int) {
        let model = ReviewModel.Request(id: id)
        NetworkService.share.request(endpoint: Endpoint.movieReviews(model: model)) { result in
            switch result {
            case .success(let response):
                let _response = ReviewModel.Response(data: response)
                self.presenter?.presentGetReviews(response: _response)
            case .failure(let error):
                self.presenter?.presentGetReviewsError(error: error)
            }
        }
    }
}
