//
//  Work.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import Foundation

struct Work {
    var id: Int
    var title: String
    var imageURL: String?
    var isFavorited: Bool
}

extension Work {
    init(realm: RealmWork) {
        self.init(
            id: realm.id,
            title: realm.title,
            imageURL: realm.imageURL,
            isFavorited: true
        )
    }

    init(entity: WorkEntity) {
        self.init(
            id: entity.id,
            title: entity.title,
            imageURL: entity.image.url,
            isFavorited: false
        )
    }
}
