//
//  OnboardingView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class OnboardingView: UIView {
    enum Step: Int {
        case started, topics, state, language, gender, age, goals, whenTaking, time, count, experience, question1, question2, question3, question4, preloader, plan
    }
    
    var didFinish: (() -> Void)?
    var didChangedSlide: ((Step) -> Void)?
    
    var step = Step.started {
        didSet {
            scroll()
            headerUpdate()
        }
    }
    
    lazy var scrollView = makeScrollView()
    lazy var progressView = makeProgressView()
    lazy var skipButton = makeSkipButton()
    
    private lazy var contentViews: [OSlideView] = {
        [
            OSlideStartedView(step: .started),
            OSlideTopicsView(step: .topics),
            OSlideStateView(step: .state),
            OSlideLanguageView(step: .language),
            OSlideGenderView(step: .gender),
            OSlideAgeView(step: .age),
            OSlideGoalsView(step: .goals),
            OSlideWhenTakingView(step: .whenTaking),
            OSlideTimeView(step: .time),
            OSlideCountView(step: .count),
            OSlideExperienceView(step: .experience),
            OSlideQuestionView(step: .question1, questionKey: "Onboarding.Question1"),
            OSlideQuestionView(step: .question2, questionKey: "Onboarding.Question2"),
            OSlideQuestionView(step: .question3, questionKey: "Onboarding.Question3"),
            OSlideQuestionView(step: .question4, questionKey: "Onboarding.Question4"),
            OSlidePreloaderView(step: .preloader),
            OSlidePlanView(step: .plan)
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        headerUpdate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OSlideViewDelegate
extension OnboardingView: OSlideViewDelegate {
    func slideViewDidNext(from step: Step) {
        OnboardingAnalytics().log(step: step)
        
        didChangedSlide?(step)
        
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            didFinish?()
            
            return
        }
        
        self.step = nextStep
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        
        contentViews
            .enumerated()
            .forEach { [weak self] index, view in
                scrollView.addSubview(view)
                
                view.delegate = self
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews.count),
                                        height: UIScreen.main.bounds.height)
    }
    
    func scroll() {
        let index = step.rawValue
        
        guard contentViews.indices.contains(index) else {
            return
        }
        
        let view = contentViews[index]
        let frame = contentViews[index].frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
        
        view.moveToThis()
    }
    
    func headerUpdate() {
        switch step {
        case .started, .topics, .state, .preloader, .plan:
            skipButton.isHidden = true
            progressView.isHidden = true
        default:
            skipButton.isHidden = false
            progressView.isHidden = false
        }
        
        let progressCases: [Step] = [
            .language, .gender, .age, .goals, .whenTaking, .time, .count, .experience, .question1, .question2, .question3, .question4
        ]
        guard let index = progressCases.firstIndex(of: step) else {
            return
        }
        progressView.progress = Float(index + 1) / Float(progressCases.count)
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: skipButton.leadingAnchor, constant: -24.scale),
            progressView.centerYAnchor.constraint(equalTo: skipButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: topAnchor, constant: 69.scale),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = UIColor(integralRed: 60, green: 75, blue: 159)
        view.progressTintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkipButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.SFProRounded.regular(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.Skip".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
