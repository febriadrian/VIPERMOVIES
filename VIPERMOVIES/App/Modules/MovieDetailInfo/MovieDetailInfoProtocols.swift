//
//  MovieDetailInfoProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IMovieDetailInfoViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IMovieDetailInfoPresenterToView? { get set }
    var interactor: IMovieDetailInfoPresenterToInteractor? { get set }
    var router: IMovieDetailInfoPresenterToRouter? { get set }

    func setupParameters()
}

protocol IMovieDetailInfoInteractorToPresenter: class {
    //
}

protocol IMovieDetailInfoPresenterToView: class {
    //
}

protocol IMovieDetailInfoPresenterToInteractor: class {
    var presenter: IMovieDetailInfoInteractorToPresenter? { get set }
    //
}

protocol IMovieDetailInfoPresenterToRouter: class {
    var view: MovieDetailInfoViewController? { get set }
    //
}
