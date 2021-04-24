//
//  OSlideLanguage.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit
import RxSwift

final class OSlideLanguageView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var langSpanishView = makeLangSpanishView()
    lazy var langEnglishView = makeLangEnglishView()
    lazy var button = makeButton()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideLanguageView {
    func initialize() {
        manager.obtainSelectedLanguage()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] language in
                guard let self = self, let lang = language else {
                    return
                }
                
                self.langSpanishView.isSelected = lang == .spanish
                self.langEnglishView.isSelected = lang == .english
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .flatMap { [weak self] _ -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                var language: Language?
                
                if self.langSpanishView.isSelected {
                    language = .spanish
                } else if self.langEnglishView.isSelected {
                    language = .english
                }
                
                if let lang = language {
                    return self.manager.saveSelected(language: lang)
                } else {
                    return .deferred {
                        .just(Void())
                    }
                }
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                self?.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func selectedLangSpanish() {
        langSpanishView.isSelected = true
        langEnglishView.isSelected = false
    }
    
    @objc
    func selectedLangEnglish() {
        langSpanishView.isSelected = false
        langEnglishView.isSelected = true
    }
}

// MARK: Make constraints
private extension OSlideLanguageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.bottomAnchor.constraint(equalTo: langSpanishView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            langSpanishView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            langSpanishView.widthAnchor.constraint(equalToConstant: 166.scale),
            langSpanishView.heightAnchor.constraint(equalToConstant: 205.scale),
            langSpanishView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            langEnglishView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            langEnglishView.widthAnchor.constraint(equalToConstant: 166.scale),
            langEnglishView.heightAnchor.constraint(equalToConstant: 205.scale),
            langEnglishView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
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
private extension OSlideLanguageView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideLanguage.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLangSpanishView() -> OLanguageSelectView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedLangSpanish))
        
        let view = OLanguageSelectView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLangEnglishView() -> OLanguageSelectView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedLangEnglish))
        
        let view = OLanguageSelectView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
            .font(Fonts.SFProRounded.semiBold(size: 18.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}