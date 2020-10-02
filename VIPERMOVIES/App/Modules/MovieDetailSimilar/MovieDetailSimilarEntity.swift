//
//  MovieDetailSimilarEntity.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import SwiftyJSON

struct SimilarMoviesModel {
    struct Request {
        var id: Int

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "page": 1,
                "language": "en-US"
            ]
        }
    }

    struct Response {
        // do something
    }

    struct ViewModel {
        // do something
    }
}
