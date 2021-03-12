//
//  UserViewModel.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import RxSwift
import RxRelay

struct UserViewModel {
    let works = BehaviorRelay<[Work]>(value: [])

    func fetch() -> Single<[Work]> {
        Single.just([])
    }
}
