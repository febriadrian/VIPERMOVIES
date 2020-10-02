//
//  DiscoverMoviesRouter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class DiscoverMoviesRouter: IDiscoverMoviesPresenterToRouter {
    var view: DiscoverMoviesViewController?

    func navToMovieDetail(id: Int) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id
        ]), completion: nil)
    }

    func navToGenres(selectedIndex: [IndexPath]?) {
        view?.navigate(type: .presentWithNavigation, module: GeneralRoute.genres(parameter: [
            "selectedIndex": selectedIndex
        ]), completion: { controller in
            guard let module = controller as? GenresViewController else { return }
            module.delegate = self.view
        })
    }
}
