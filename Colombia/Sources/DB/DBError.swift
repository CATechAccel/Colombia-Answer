//
//  DBError.swift
//  Colombia
//
//  Created by 伊藤凌也 on 2021/03/13.
//

enum DBError: Error {
    case itemNotFound
    case unknown(Error)
}
