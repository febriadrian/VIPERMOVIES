//
//  MovieDetailReviewPresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class MovieDetailReviewPresenter: IMovieDetailReviewViewToPresenter {
    var parameters: [String: Any]?
    var view: IMovieDetailReviewPresenterToView?
    var interactor: IMovieDetailReviewPresenterToInteractor?
    var router: IMovieDetailReviewPresenterToRouter?
    var presenter: IMovieDetailReviewViewToPresenter?
    var reviews: [ReviewModel.ViewModel] = []
    var id: Int?
    var resultsCount: Int?

    func setupParameters() {
        id = parameters?["id"] as? Int
    }

    func getReviews() {
        guard let id = id else { return }
        interactor?.getReviews(id: id)
    }
}

extension MovieDetailReviewPresenter: IMovieDetailReviewInteractorToPresenter {
    func presentGetReviews(response: ReviewModel.Response) {
        guard let results = response.results, results.count > 0 else {
            resultsCount = 0
            presentGetReviewsError(error: nil)
            return
        }

        reviews = results.map { ReviewModel.ViewModel(review: $0) }
        view?.displayGetMovies(result: .success, reviews: reviews)
    }

    func presentGetReviewsError(error: Error?) {
        var message = Messages.noInternet

        if error != nil {
            message = Messages.unknownError
        } else if resultsCount == 0 {
            message = Messages.noReviews
            resultsCount = nil
        }

        view?.displayGetMovies(result: .failure(message), reviews: reviews)
    }
}
