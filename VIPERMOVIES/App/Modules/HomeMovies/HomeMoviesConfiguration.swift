//
//  HomeMoviesConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class HomeMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = HomeMoviesViewController()
        let presenter: IHomeMoviesViewToPresenter & IHomeMoviesInteractorToPresenter = HomeMoviesPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = HomeMoviesRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = HomeMoviesInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
