//
//  RealmRepository.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import RxSwift

struct RealmRepository {
    func fetchFavoriteWorks() -> Single<[Work]> {
        Single.just([]) // TODO: fix
    }

    func favorite(work: Work) -> Single<Void> {
        Single.just(()) // TODO: fix
    }

    func unFavorite(workId: Int) -> Single<Void> {
        Single.just(()) // TODO: fix
    }
}
