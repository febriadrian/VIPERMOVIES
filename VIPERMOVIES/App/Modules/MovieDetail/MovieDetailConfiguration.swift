//
//  MovieDetailConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = MovieDetailViewController()
        let presenter: IMovieDetailViewToPresenter & IMovieDetailInteractorToPresenter = MovieDetailPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = MovieDetailRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = MovieDetailInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
