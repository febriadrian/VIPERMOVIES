//
//  MovieDetailReviewProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IMovieDetailReviewViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IMovieDetailReviewPresenterToView? { get set }
    var interactor: IMovieDetailReviewPresenterToInteractor? { get set }
    var router: IMovieDetailReviewPresenterToRouter? { get set }
    var id: Int? { get }

    func setupParameters()
    func getReviews()
}

protocol IMovieDetailReviewInteractorToPresenter: class {
    func presentGetReviews(response: ReviewModel.Response)
    func presentGetReviewsError(error: Error?)
}

protocol IMovieDetailReviewPresenterToView: class {
    func displayGetMovies(result: GeneralResult, reviews: [ReviewModel.ViewModel])
}

protocol IMovieDetailReviewPresenterToInteractor: class {
    var presenter: IMovieDetailReviewInteractorToPresenter? { get set }

    func getReviews(id: Int)
}

protocol IMovieDetailReviewPresenterToRouter: class {
    var view: MovieDetailReviewViewController? { get set }
    //
}
