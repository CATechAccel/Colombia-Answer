//
//  APIClient.swift
//  Colombia
//
//  Created by 山根大生 on 2021/02/19.
//

import Foundation
import RxSwift

struct APIClient {
    private let decoder = JSONDecoder()
    
    func request<T: Requestable>(_ request: T) -> Single<T.Response> {
        Single<T.Response>.create { single in
            let task = URLSession.shared.dataTask(with: request.url) { data, _, error in
                if let error = error {
                    single(.failure(error))
                }

                guard let data = data else {
                    single(.failure(APIError.resultNotFound))
                    return
                }

                do {
                    let response = try decoder.decode(T.Response.self, from: data)
                    single(.success(response))
                } catch let error {
                    single(.failure(APIError.decodeFailed(error)))
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
}

enum APIError: Error {
    case resultNotFound
    case decodeFailed(Error)
}
