//
//  FavoriteMoviesConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class FavoriteMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = FavoriteMoviesViewController()
        let presenter: IFavoriteMoviesViewToPresenter & IFavoriteMoviesInteractorToPresenter = FavoriteMoviesPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = FavoriteMoviesRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = FavoriteMoviesInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
