//
//  HomeViewModel.swift
//  Colombia
//
//  Created by 化田晃平 on R 3/02/25.
//

import RxCocoa
import RxSwift
import RxRelay

protocol HomeViewModelInput {
    var input: HomeViewModelInput { get }

    func viewDidLoad()
    func refresh()
}

protocol HomeViewModelOutput {
    var output: HomeViewModelOutput { get }

    var works: Driver<[Work]> { get }

    func showWork(work: Work)
}

struct HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    struct Dependency {
        var router: MainRouter
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

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
