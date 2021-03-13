//
//  RealmRepository.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import RxSwift

struct RealmRepository {
    private let dbClient = DBClient.shared

    func fetchFavoriteWorks() -> [Work] {
        dbClient.select()
            .map(Work.init(realm:))
    }

    func favorite(work: Work) -> Result<Work, DBError> {
        dbClient.create(object: RealmWork(work: work))
            .map(Work.init(realm:))
    }

    func unFavorite(workId: Int) -> Result<Work, DBError> {
        dbClient.item(id: workId)
            .flatMap(dbClient.delete(object:))
            .map(Work.init(realm:))
    }
}
