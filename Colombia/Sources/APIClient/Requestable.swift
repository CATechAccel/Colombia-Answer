//
//  Requestable.swift
//  Colombia
//
//  Created by 山根大生 on 2021/02/14.
//

import Foundation

protocol Requestable {
    associatedtype Response: Decodable
    var url: URL { get }
}
