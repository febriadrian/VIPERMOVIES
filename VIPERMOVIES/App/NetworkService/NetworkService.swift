//
//  NetworkService.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

typealias successHandler = (_ data: JSON?) -> Void
typealias failureHandler = (_ error: Error?) -> Void

enum TheMoviesResult<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

protocol IEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: Parameters? { get }
    var header: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

struct NetworkStatus {
    static var isInternetAvailable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class NetworkService {
    static let share = NetworkService()
    private var dataRequest: DataRequest?

    @discardableResult
    private func _dataRequest(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    )
        -> DataRequest {
        return SessionManager.default.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }

    func request<T: IEndpoint>(endpoint: T, completion: ((TheMoviesResult<JSON?, Error?>) -> Void)? = nil) {
        guard NetworkStatus.isInternetAvailable else {
            completion?(.failure(nil))
            return
        }

        DispatchQueue.global(qos: .background).async {
            self.dataRequest = self._dataRequest(url: endpoint.path,
                                                 method: endpoint.method,
                                                 parameters: endpoint.parameter,
                                                 encoding: endpoint.encoding,
                                                 headers: endpoint.header)

            self.dataRequest?.responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    completion?(.success(JSON(value)))
                case .failure(let error):
                    completion?(.failure(error))
                }
            })
        }
    }
}
