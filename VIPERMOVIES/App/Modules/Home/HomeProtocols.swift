//
//  HomeProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IHomeViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IHomePresenterToView? { get set }
    var interactor: IHomePresenterToInteractor? { get set }
    var router: IHomePresenterToRouter? { get set }
    var mainViewController: MainViewController? { get }
    
    func setupParameters()
}

protocol IHomeInteractorToPresenter: class {
    //
}

protocol IHomePresenterToView: class {
    //
}

protocol IHomePresenterToInteractor: class {
    var presenter: IHomeInteractorToPresenter? { get set }
}

protocol IHomePresenterToRouter: class {
    var view: HomeViewController? { get set }
}

protocol HomeViewControllerDelegate {
    func scrollToTop()
}
