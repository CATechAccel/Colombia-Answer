//
//  Work.swift
//  Colombia
//
//  Created by 伊藤凌也 on 2021/03/13.
//

import RealmSwift

final class RealmWork: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var createAt = Date()

    required override init() {
        super.init()
    }

    convenience init(id: Int, title: String, imageURL: String?) {
        self.init()
        self.id = id
        self.title = title
        self.imageURL = imageURL
    }

    override class func primaryKey() -> String? {
        "id"
    }
}

extension RealmWork {
    convenience init(work: Work) {
        self.init(id: work.id, title: work.title, imageURL: work.imageURL)
    }
}
