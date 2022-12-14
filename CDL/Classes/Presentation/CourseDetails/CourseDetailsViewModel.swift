//
//  CourseDetailsViewModel.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import Foundation
import RxSwift
import RxCocoa
import RushSDK

final class CourseDetailsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    let course = BehaviorRelay<Course?>(value: nil)
    
    private lazy var questionManager = QuestionManager()
    private lazy var sessionManager = SessionManager()
    
    lazy var passRate = course.asDriver().compactMap { $0?.progress }
    lazy var courseId = course.asDriver().compactMap { $0?.id }
    lazy var elements = makeElements()
    lazy var config = makeConfig().share(replay: 1, scope: .forever)
    
    lazy var activity = RxActivityIndicator()
    
    lazy var activeSubscription = makeActiveSubscription().share(replay: 1, scope: .forever)
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

extension CourseDetailsViewModel {
    func makeElements() -> Driver<[CourseDetailsTableElement]> {
        Observable.combineLatest(activeSubscription, config)
            .map { activeSubscription, elements -> [CourseDetailsTableElement] in
                var result = elements.map { CourseDetailsTableElement.test(.init(config: $0)) }
                if !activeSubscription {
                    if result.count > 2 {
                        result.insert(.needPayment, at: 2)
                    } else {
                        result.append(.needPayment)
                    }
                }
                return result
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeConfig() -> Observable<[TestConfig]> {
        let config = courseId
            .asObservable()
            .flatMapLatest { [weak self] courseId -> Observable<[TestConfig]> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<CourseConfig> {
                    self.questionManager
                        .obtainConfig(courseId: courseId)
                        .flatMap { config -> Single<CourseConfig> in
                            guard let config = config else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(config)
                        }
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
                    .map { $0.testsConfigs }
            }
        
        return Signal
            .merge(
                QuestionMediator.shared.testPassed,
                TestCloseMediator.shared.testClosed.map { _ in Void() },
                SITestCloseMediator.shared.testClosed
            )
            .asObservable()
            .startWith(())
            .flatMapLatest { _ in config }
    }
    
    func makeActiveSubscription() -> Observable<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
            .asObservable()
    }
}
