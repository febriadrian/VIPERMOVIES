//
//  GenresEntity.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import SwiftyJSON

enum GeneralResult {
    case success
    case failure(String)
}

struct GenresModel {
    struct Request {
        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey
            ]
        }
    }

    struct Response {
        var genres: [Genres]?

        init(data: JSON?) {
            if let items = data?["genres"].array {
                self.genres = items.map { Genres(data: JSON($0.object)) }
            }
        }

        struct Genres {
            var id: Int?
            var name: String?

            init(data: JSON?) {
                self.id = data?["id"].int
                self.name = data?["name"].string
            }
        }
    }

    struct ViewModel {
        var id: Int
        var name: String
    }
}
