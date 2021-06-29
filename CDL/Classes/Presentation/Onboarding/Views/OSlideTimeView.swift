//
//  OSlide7View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit
import RxSwift

final class OSlideTimeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cursorView = makeCursorView()
    lazy var pickerView = makePickerView()
    lazy var minLabel = makeMinLabel()
    lazy var button = makeButton()
    
    private lazy var selectedMinutes = 0
    
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

// MARK: UIPickerViewDataSource
extension OSlideTimeView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        12
    }
}

// MARK: UIPickerViewDelegate
extension OSlideTimeView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel()
            label?.backgroundColor = UIColor.clear
        }
        
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText)
            .font(Fonts.Lato.bold(size: 32.scale))
            .lineHeight(38.scale)
        
        label?.attributedText = String((row + 1) * 5).attributed(with: attrs)
        
        label?.sizeToFit()
        
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50.scale
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMinutes = (row + 1) * 5
    }
}

// MARK: Private
private extension OSlideTimeView {
    func initialize() {
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.manager
                    .set(testMinutes: self.selectedMinutes)
                    .map { true }
                    .catchAndReturn(false)
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] success in
                guard success else {
                    Toast.notify(with: "Onboarding.FailedToSave".localized, style: .danger)
                    return
                }

                self?.onNext()
            })
            .disposed(by: disposeBag)
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(3, inComponent: 0, animated: false)
    }
}

// MARK: Make constraints
private extension OSlideTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale),
            pickerView.widthAnchor.constraint(equalToConstant: 375.scale),
            pickerView.heightAnchor.constraint(equalToConstant: 254.scale)
        ])
        
        NSLayoutConstraint.activate([
            cursorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 120.scale),
            cursorView.widthAnchor.constraint(equalToConstant: 24.scale),
            cursorView.heightAnchor.constraint(equalToConstant: 24.scale),
            cursorView.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -104.scale),
            minLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
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
private extension OSlideTimeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.Lato.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideTime.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCursorView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Cursor")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePickerView() -> UIPickerView {
        let view = PaddingPickerView()
        view.padding = UIEdgeInsets(top: 0, left: 200.scale, bottom: 0, right: 200.scale)
        view.backgroundColor = UIColor.clear
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMinLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText)
            .font(Fonts.Lato.bold(size: 24.scale))
        
        let view = UILabel()
        view.attributedText = "Onboarding.SlideTime.Min".localized.attributed(with: attrs)
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
