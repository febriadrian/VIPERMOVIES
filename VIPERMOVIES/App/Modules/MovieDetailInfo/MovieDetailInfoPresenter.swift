//
//  MovieDetailInfoPresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class MovieDetailInfoPresenter: IMovieDetailInfoViewToPresenter {
    var parameters: [String: Any]?
    var view: IMovieDetailInfoPresenterToView?
    var interactor: IMovieDetailInfoPresenterToInteractor?
    var router: IMovieDetailInfoPresenterToRouter?
    var presenter: IMovieDetailInfoViewToPresenter?

    func setupParameters() {
        //
    }
}

extension MovieDetailInfoPresenter: IMovieDetailInfoInteractorToPresenter {
    //
}
