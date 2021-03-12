//
//  AnnictRequest.swift
//  Colombia
//
//  Created by 山根大生 on 2021/02/16.
//

import Foundation

struct AnnictRequest: Requestable {
    typealias Response = AnnictWorksResponse
    private let endPoint: EndPoint
    
    var url: URL {
        var baseURL = URLComponents(string: "https://api.annict.com")!
        baseURL.path = endPoint.endPoint
        
        switch endPoint {
        case .works:
            baseURL.queryItems = [
                URLQueryItem(name: "per_page", value: "20"),
                // とりあえずid,title,recommended_urlのみを受け取る
                URLQueryItem(name: "fields", value: "id,title,images"),
                URLQueryItem(name: "access_token", value: Key.annictApi),
                URLQueryItem(name: "filter_season", value: "2020-spring")
            ]
        }
        return baseURL.url!
    }
    
    init(endPoint: EndPoint) {
        self.endPoint = endPoint
    }
}
