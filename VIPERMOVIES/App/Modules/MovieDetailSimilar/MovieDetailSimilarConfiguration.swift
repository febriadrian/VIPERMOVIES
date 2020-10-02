//
//  MovieDetailSimilarConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailSimilarConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = MovieDetailSimilarViewController()
        let presenter: IMovieDetailSimilarViewToPresenter & IMovieDetailSimilarInteractorToPresenter = MovieDetailSimilarPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = MovieDetailSimilarRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = MovieDetailSimilarInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
