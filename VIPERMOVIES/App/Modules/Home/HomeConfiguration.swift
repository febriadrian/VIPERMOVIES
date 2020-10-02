//
//  HomeConfiguration.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class HomeConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let view = HomeViewController()
        let presenter: IHomeViewToPresenter & IHomeInteractorToPresenter = HomePresenter()
        view.presenter = presenter
        view.presenter?.parameters = parameters
        view.presenter?.router = HomeRouter()
        view.presenter?.router?.view = view
        view.presenter?.view = view
        view.presenter?.interactor = HomeInteractor()
        view.presenter?.interactor?.presenter = presenter
        return view
    }
}
