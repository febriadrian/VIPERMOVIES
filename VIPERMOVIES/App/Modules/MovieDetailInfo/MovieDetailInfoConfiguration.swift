//
//  MovieDetailInfoConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailInfoConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = MovieDetailInfoViewController()
        let presenter: IMovieDetailInfoViewToPresenter & IMovieDetailInfoInteractorToPresenter = MovieDetailInfoPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = MovieDetailInfoRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = MovieDetailInfoInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
