//
//  FlashcardsViewModel.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift
import RxCocoa

final class FlashcardsTopicsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var courseId = BehaviorRelay<Int?>(value: nil)
    
    lazy var flashcardsTopics = makeFlashcardsTopics()
    lazy var activeSubscription = makeActiveSubscription()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var flashcardsManager = FlashcardsManagerCore()
    private lazy var sessionManager = SessionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension FlashcardsTopicsViewModel {
    func makeFlashcardsTopics() -> Driver<[FlashcardTopic]> {
        FlashCardManagerMediator.shared.rxFlashCardFinished
            .asObservable()
            .startWith(())
            .withLatestFrom(courseId.compactMap { $0 })
            .flatMapLatest { [weak self] courseId -> Observable<[FlashcardTopic]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[FlashcardTopic]> {
                    self.flashcardsManager
                        .obtainTopics(courseId: courseId)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .asDriver(onErrorJustReturn: false)
            .startWith(SessionManager().hasActiveSubscriptions())
    }
}
