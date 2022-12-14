//
//  OSlideCountryView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

import UIKit
import RxSwift

final class LocaleCountryView: UIView {
    var onNext: (() -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        changeEnabled()
        nextAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LocaleCountryView {
    func setup(countries: [Country]) {
        let countriesElements = countries
            .sorted(by: { $0.sort < $1.sort })
            .map {
                LocaleTableViewElement(isSelected: $0.preSelected,
                                       name: $0.name,
                                       code: $0.code)
            }
        
        tableView.setup(elements: countriesElements)
        
        changeEnabled()
    }
}

// MARK: Private
private extension LocaleCountryView {
    func nextAction() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onNext?()
            })
            .disposed(by: disposeBag)
    }
    
    func changeEnabled() {
        let isSelected = tableView.elements.contains(where: { $0.isSelected })

        button.isEnabled = isSelected
        button.alpha = isSelected ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension LocaleCountryView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 134.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.scale),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -32.scale)
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
private extension LocaleCountryView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.Lato.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideCountry.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> LocaleTableView {
        let view = LocaleTableView()
        view.tapped = { [weak self] in
            self?.changeEnabled()
        }
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
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
