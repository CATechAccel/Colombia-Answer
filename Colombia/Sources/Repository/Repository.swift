//
//  Repository.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import RxSwift

protocol Repository {
    associatedtype Response
    var apiClient: APIClient { get }
    func fetch() -> Single<Response>
}
