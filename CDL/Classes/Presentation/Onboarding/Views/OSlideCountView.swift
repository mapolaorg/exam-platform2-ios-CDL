//
//  OSlide8View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideCountView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var slider = makeSlider()
    lazy var button = makeButton()
    
    private lazy var valueLabel = makeValueLabel()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        update(sender: slider)
    }
}

// MARK: Private
private extension OSlideCountView {
    @objc
    func update(sender: UISlider) {
        sender.value = round(sender.value)
        
        if slider.value <= 2 {
            imageView.image = UIImage(named: "Onboarding.SlideCount.Image1")
        } else if slider.value <= 5 {
            imageView.image = UIImage(named: "Onboarding.SlideCount.Image2")
        } else {
            imageView.image = UIImage(named: "Onboarding.SlideCount.Image3")
        }
        
        valueLabel.text = sender.value >= 7 ? "7+" : String(Int(sender.value))
        valueLabel.sizeToFit()
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: roundf(sender.value))
        valueLabel.center = CGPoint(x: thumbRect.midX, y: sender.frame.minY - valueLabel.frame.height)
    }
}

// MARK: Make constraints
private extension OSlideCountView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 166.scale),
            imageView.heightAnchor.constraint(equalToConstant: 205.scale),
            imageView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -87.scale)
        ])
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            slider.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -56.scale)
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
private extension OSlideCountView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideCount.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(integralRed: 245, green: 245, blue: 245)
        view.font = Fonts.SFProRounded.bold(size: 32.scale)
        addSubview(view)
        return view
    }
    
    func makeSlider() -> OSlider {
        let view = OSlider()
        view.minimumValue = 1
        view.maximumValue = 7
        view.minimumTrackTintColor = UIColor(integralRed: 249, green: 205, blue: 106)
        view.maximumTrackTintColor = UIColor(integralRed: 60, green: 75, blue: 159)
        view.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
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
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}