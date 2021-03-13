//
//  UserViewModel.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import RxSwift
import RxRelay

import RxCocoa
import RxSwift
import RxRelay

protocol UserViewModelInput {
    var input: UserViewModelInput { get }

    func viewDidLoad()
    func refresh()
    func showWork(work: Work)
}

protocol UserViewModelOutput {
    var output: UserViewModelOutput { get }

    var works: Driver<[Work]> { get }
}

struct UserViewModel: UserViewModelInput, UserViewModelOutput {
    struct Dependency {
        var router: MainRouter
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()

    var input: UserViewModelInput { self }
    var output: UserViewModelOutput { self }

    init(dependency: Dependency) {
        self.dependency = dependency
        Observable.merge([
            viewDidLoadRelay.asObservable(),
            refreshRelay.asObservable(),
        ])
            .flatMap(fetch)
            .bind(to: worksRelay)
            .disposed(by: disposeBag)
    }

    func showWork(work: Work) {
        dependency.router.transition(to: .work(work))
    }

    private func fetch() -> Single<[Work]> {
        Single.just([])
    }

    // Input
    private let viewDidLoadRelay = PublishRelay<Void>()
    func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
    private let refreshRelay = PublishRelay<Void>()
    func refresh() {
        refreshRelay.accept(())
    }

    // Output
    private let worksRelay = BehaviorRelay<[Work]>(value: [])
    var works: Driver<[Work]> {
        worksRelay.asDriver()
    }
}
