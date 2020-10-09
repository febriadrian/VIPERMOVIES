//
//  FavoriteDB.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteDB {
    static let share = FavoriteDB()
    private let realm = try! Realm()

    func save(movie: MoviesModel.ViewModel) {
        let object = FavoriteObject()
        object.createdAt = Int(Date().timeIntervalSince1970)
        object.favorite = true
        object.id = movie.id
        object.title = movie.title
        object.posterUrl = movie.posterUrl
        object.voteAverage = movie.voteAverage
        object.overview = movie.overview
        object.releaseDate = movie.releaseDate

        try! realm.write {
            realm.add(object, update: .all)
        }
    }

    func list() -> [MoviesModel.ViewModel] {
        var movies = load().map {
            MoviesModel.ViewModel(
                id: $0.id,
                title: $0.title,
                posterUrl: $0.posterUrl,
                voteAverage: $0.voteAverage,
                overview: $0.overview,
                releaseDate: $0.releaseDate,
                favorite: $0.favorite,
                createdAt: $0.createdAt
            )
        }

        movies.sort(by: { $0.createdAt > $1.createdAt })
        return movies
    }

    func checkIsFavorite(id: Int) -> Bool {
        let filter = "(id = \(id))"
        let movie = load(filter: filter)
        if movie.count == 1 {
            return true
        }
        return false
    }

    func remove(id: Int) {
        let filter = "(id = \(id))"
        guard let movie = load(filter: filter).first else { return }
        try! realm.write {
            realm.delete(movie)
        }
    }

    private func load(filter: String? = nil) -> [FavoriteObject] {
        if let filter = filter, !filter.isEmpty {
            let results = realm.objects(FavoriteObject.self).filter(filter).toArray(ofType: FavoriteObject.self) as [FavoriteObject]
            return results
        }

        let results = realm.objects(FavoriteObject.self).toArray(ofType: FavoriteObject.self) as [FavoriteObject]
        return results
    }
}

class FavoriteObject: Object {
    @objc dynamic var createdAt: Int = 0
    @objc dynamic var favorite: Bool = false
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var posterUrl: String = ""
    @objc dynamic var voteAverage: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var releaseDate: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
