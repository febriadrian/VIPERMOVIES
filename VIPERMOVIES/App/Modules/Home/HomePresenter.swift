//
//  HomePresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class HomePresenter: IHomeViewToPresenter {
    var parameters: [String: Any]?
    var view: IHomePresenterToView?
    var interactor: IHomePresenterToInteractor?
    var router: IHomePresenterToRouter?
    var presenter: IHomeViewToPresenter?
    var mainViewController: MainViewController?

    func setupParameters() {
        mainViewController = parameters?["mainvc"] as? MainViewController
    }
}

extension HomePresenter: IHomeInteractorToPresenter {
    //
}
