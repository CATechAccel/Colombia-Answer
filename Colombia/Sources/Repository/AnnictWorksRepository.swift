//
//  AnnictWorksRepository.swift
//  Colombia
//
//  Created by 山根大生 on 2021/02/19.
//

import RxSwift

struct AnnictWorksRepository: Repository {
    let apiClient = APIClient()
    
    typealias Response = AnnictWorksResponse
    
    func fetch() -> Single<Response> {
        let request = AnnictRequest(endPoint: .works(season: .spring2020))
        return apiClient.request(request)
    }
}
