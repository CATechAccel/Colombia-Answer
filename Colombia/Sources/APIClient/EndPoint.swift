//
//  EndPoint.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

enum EndPoint {
    //とりあえずworksだけ実装
    case works

    var endPoint: String {
        switch self {
        case .works:
            return "/v1/works"
        }
    }
}
