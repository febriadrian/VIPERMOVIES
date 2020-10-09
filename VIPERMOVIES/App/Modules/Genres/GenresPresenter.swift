//
//  GenresPresenter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class GenresPresenter: IGenresViewToPresenter {
    var parameters: [String: Any]?
    var view: IGenresPresenterToView?
    var interactor: IGenresPresenterToInteractor?
    var router: IGenresPresenterToRouter?
    var presenter: IGenresViewToPresenter?
    var genres: [GenresModel.ViewModel] = []
    var genresIds: [String] = []
    var selectedIndex: [IndexPath]?
    var selectedCount: Int {
        return genresIds.count
    }

    func setupParameters() {
        selectedIndex = parameters?["selectedIndex"] as? [IndexPath]
    }

    func getGenres() {
        genres = GenresDB.share.list()

        if genres.count == 0 {
            interactor?.getGenres()
        } else {
            view?.displayGetGenres(result: .success, genres: genres)
        }
    }

    func didSelectGenreId(at index: Int) {
        let id = "\(genres[index].id)"
        genresIds.append(id)
    }

    func didDeselectGenreId(at index: Int) {
        let id = "\(genres[index].id)"
        if let index = genresIds.firstIndex(of: id) {
            genresIds.remove(at: index)
        }
    }
}

extension GenresPresenter: IGenresInteractorToPresenter {
    func presentGetGenres(response: GenresModel.Response) {
        guard let results = response.genres, results.count > 0 else {
            presentGetGenresError(error: nil)
            return
        }

        genres = results.map {
            GenresModel.ViewModel(
                id: $0.id ?? 0,
                name: $0.name ?? ""
            )
        }

        GenresDB.share.save(genres: genres)
        view?.displayGetGenres(result: .success, genres: genres)
    }

    func presentGetGenresError(error: Error?) {
        var message = Messages.noInternet
        if error != nil {
            message = Messages.unknownError
        }

        view?.displayGetGenres(result: .failure(message), genres: genres)
    }
}
