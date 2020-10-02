//
//  DiscoverMoviesConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class DiscoverMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = DiscoverMoviesViewController()
        let presenter: IDiscoverMoviesViewToPresenter & IDiscoverMoviesInteractorToPresenter = DiscoverMoviesPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = DiscoverMoviesRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = DiscoverMoviesInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
