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
    func showWork(work: Work)
    func favoriteWork(work: Work)
    func unfavoriteWork(work: Work)
}

protocol HomeViewModelOutput {
    var output: HomeViewModelOutput { get }

    var works: Driver<[Work]> { get }
    var loadingStatus: Driver<LoadingStatus> { get }
}

struct HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    struct Dependency {
        var router: MainRouter
        var annictWorksRepository: AnnictWorksRepository
        var realmRepository: RealmRepository
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    init(dependency: Dependency) {
        self.dependency = dependency

        let fetched = Observable.merge([
            viewDidLoadRelay.asObservable(),
            refreshRelay.asObservable(),
        ])
            .do(onNext: { [self] in
                loadingStatusRelay.accept(.loading)
            })
            .flatMap(dependency.annictWorksRepository.fetch)
            .materialize()
            .share()

        fetched
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .do(onNext: { [self] _ in
                loadingStatusRelay.accept(.loaded)
            })
            .map { $0.works.map(Work.init(entity:)) }
            .withLatestFrom(Observable.just(dependency.realmRepository.fetchFavoriteWorks())) { ($0, $1) }
            .map { works, favoriteWorks -> [Work] in
                let favoritedIds: [Int] = favoriteWorks.map(\.id)
                return works.map {
                    var work = $0
                    work.isFavorited = favoritedIds.contains($0.id)
                    return work
                }
            }
            .bind(to: worksRelay)
            .disposed(by: disposeBag)

        fetched
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .do(onNext: { [self] _ in
                loadingStatusRelay.accept(.loadFailed)
            })
            .subscribe()
            .disposed(by: disposeBag)


        favoriteWorkRelay.asObservable()
            .map(dependency.realmRepository.favorite(work:))
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    break
                case .failure:
                    // TODO: Error handling
                    break
                }
            }).disposed(by: disposeBag)

        unfavoriteWorkRelay.asObservable()
            .map(\.id)
            .map(dependency.realmRepository.unFavorite(workId:))
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    break
                case .failure:
                    // TODO: Error handling
                    break
                }
            }).disposed(by: disposeBag)
    }

    func showWork(work: Work) {
        dependency.router.transition(to: .work(work))
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
    private let favoriteWorkRelay = PublishRelay<Work>()
    func favoriteWork(work: Work) {
        favoriteWorkRelay.accept(work)
    }
    private let unfavoriteWorkRelay = PublishRelay<Work>()
    func unfavoriteWork(work: Work) {
        unfavoriteWorkRelay.accept(work)
    }

    // Output
    private let worksRelay = BehaviorRelay<[Work]>(value: [])
    var works: Driver<[Work]> {
        worksRelay.asDriver()
    }
    private let loadingStatusRelay = BehaviorRelay<LoadingStatus>(value: .initial)
    var loadingStatus: Driver<LoadingStatus> {
        loadingStatusRelay.asDriver()
    }
}
