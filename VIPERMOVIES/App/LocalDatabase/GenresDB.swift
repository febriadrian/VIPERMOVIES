//
//  GenresDB.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RealmSwift

class GenresDB {
    static let share = GenresDB()
    private let realm = try! Realm()

    func save(genres: [GenresModel.ViewModel]) {
        for x in genres {
            let object = GenresObject()
            object.id = x.id
            object.name = x.name

            try! realm.write {
                realm.add(object, update: .all)
            }
        }
    }

    func list() -> [GenresModel.ViewModel] {
        let genres = load().map { GenresModel.ViewModel(id: $0.id, name: $0.name) }
        return genres
    }

    private func load() -> [GenresObject] {
        let results = realm.objects(GenresObject.self).toArray(ofType: GenresObject.self) as [GenresObject]
        return results
    }
}

class GenresObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
