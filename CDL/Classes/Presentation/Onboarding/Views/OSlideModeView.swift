//
//  OSlideModeView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 20.06.2021.
//

import UIKit
import RxSwift

final class OSlideModeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    lazy var modesView = makeModesView()
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideModeView {
    func initialize() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                guard let selected = self.modesView.elements.first(where: { $0.isSelected }) else {
                    return
                }
                
                self.scope.testMode = selected.code
                
                self.onNext()
            })
            .disposed(by: disposeBag)
        
        modesView.setup(elements: [
            .init(title: "Onboarding.Mode.Cell2.Title".localized,
                  subtitle: "Onboarding.Mode.Cell2.Subtitle".localized,
                  code: TestMode.fullComplect,
                  isSelected: true),
            
            .init(title: "Onboarding.Mode.Cell1.Title".localized,
                  subtitle: "Onboarding.Mode.Cell1.Subtitle".localized,
                  code: TestMode.noExplanations,
                  isSelected: false),
            
            .init(title: "Onboarding.Mode.Cell3.Title".localized,
                  subtitle: "Onboarding.Mode.Cell3.Subtitle".localized,
                  code: TestMode.onAnExam,
                  isSelected: false)
        ], isNeedScroll: false)
    }
}

// MARK: Make constraints
private extension OSlideModeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            subtitleLabel.bottomAnchor.constraint(equalTo: modesView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            modesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            modesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            modesView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale),
            modesView.heightAnchor.constraint(equalToConstant: 195.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 53.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideModeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText)
            .font(Fonts.Lato.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Mode.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText.withAlphaComponent(0.6))
            .font(Fonts.Lato.regular(size: 18.scale))
            .lineHeight(25.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Mode.Subtitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeModesView() -> OModesCollectionView {
        let layout = OModesCollectionLayout()
        layout.itemSize = CGSize(width: 316.scale, height: .zero)
        
        let view = OModesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.Lato.regular(size: 18.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
