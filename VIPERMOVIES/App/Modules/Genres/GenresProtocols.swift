//
//  GenresProtocols.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IGenresViewToPresenter: class {
    var parameters: [String: Any]? { get set }
    var view: IGenresPresenterToView? { get set }
    var interactor: IGenresPresenterToInteractor? { get set }
    var router: IGenresPresenterToRouter? { get set }
    var genresIds: [String] { get }
    var selectedCount: Int { get }
    var selectedIndex: [IndexPath]? { get set }

    func setupParameters()
    func getGenres()
    func didSelectGenreId(at index: Int)
    func didDeselectGenreId(at index: Int)
}

protocol IGenresInteractorToPresenter: class {
    func presentGetGenres(response: GenresModel.Response)
    func presentGetGenresError(error: Error?)
}

protocol IGenresPresenterToView: class {
    func displayGetGenres(result: GeneralResult, genres: [GenresModel.ViewModel])
}

protocol IGenresPresenterToInteractor: class {
    var presenter: IGenresInteractorToPresenter? { get set }

    func getGenres()
}

protocol IGenresPresenterToRouter: class {
    var view: GenresViewController? { get set }
    //
}

protocol GenresDelegate {
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?)
}
