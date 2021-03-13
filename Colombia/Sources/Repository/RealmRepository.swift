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

    func unFavorite(workId: Int) -> Result<Int, DBError> {
        let item: Result<RealmWork, DBError> = dbClient.item(id: workId)
        return item
            .flatMap(dbClient.delete(object:))
            .map { _ in workId }
    }
}
