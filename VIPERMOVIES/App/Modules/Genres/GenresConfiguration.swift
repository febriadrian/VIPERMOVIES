//
//  GenresConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class GenresConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = GenresViewController()
        let presenter: IGenresViewToPresenter & IGenresInteractorToPresenter = GenresPresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = GenresRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = GenresInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
