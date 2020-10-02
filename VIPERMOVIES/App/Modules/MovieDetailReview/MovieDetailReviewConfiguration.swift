//
//  MovieDetailReviewConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailReviewConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = MovieDetailReviewViewController()
        let presenter: IMovieDetailReviewViewToPresenter & IMovieDetailReviewInteractorToPresenter = MovieDetailReviewPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = MovieDetailReviewRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = MovieDetailReviewInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
