//
//  MovieDetailProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

protocol IMovieDetailViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IMovieDetailPresenterToView? { get set }
    var interactor: IMovieDetailPresenterToInteractor? { get set }
    var router: IMovieDetailPresenterToRouter? { get set }
    var isInitialLoading: Bool { get }
    var id: Int? { get }
    var movieTitle: String { get }

    func setupParameters()
    func getMovieDetail()
    func updateFavorite()
}

protocol IMovieDetailInteractorToPresenter: class {
    func presentGetMovieDetail(response: MovieDetailModel.Response)
    func presentGetMovieDetail(error: Error?)
    func presentUpdateFavorite()
}

protocol IMovieDetailPresenterToView: class {
    func displayGetMovieDetail(result: GeneralResult, detail: MovieDetailModel.MVDetailModel, cast: [MovieDetailModel.PersonModel], crew: [MovieDetailModel.PersonModel], trailers: [MovieDetailModel.YoutubeTrailerModel])
    func displayUpdateFavorite(favorite: Bool)
}

protocol IMovieDetailPresenterToInteractor: class {
    var presenter: IMovieDetailInteractorToPresenter? { get set }

    func getMovieDetail(id: Int)
    func updateFavorite(movie: MoviesModel.ViewModel, favorite: Bool)
}

protocol IMovieDetailPresenterToRouter: class {
    var view: MovieDetailViewController? { get set }
    //
}

protocol MovieDetailInfoDelegate {
    func updateCell()
}

protocol MovieDetailScrollDelegate {
    func didScroll(yOffset: CGFloat)
}
