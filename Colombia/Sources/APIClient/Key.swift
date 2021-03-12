//
//  Key.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import Foundation

enum Key {
    static var annictApi: String {
        guard let filePath = Bundle.main.path(forResource: "AccessToken", ofType: "plist") else {
                    fatalError("Couldn't find file 'AccessToken.plist'")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "AnnictAPIAccessToken") as? String else {
            fatalError("Couldn't find key 'AnnictAPIAccessToken' in 'AccessToken.plist'")
        }
        return value
    }
}
