//
//  SCFlashcardsCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 09.06.2021.
//

import UIKit

final class SCFlashcardsCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var titleLabel = makeLabel()
    lazy var topicsToLearnCountLabel = makeLabel()
    lazy var topicsToLearnTitleLabel = makeLabel()
    lazy var topicsLearnedCountLabel = makeLabel()
    lazy var topicsLearnedTitleLabel = makeLabel()
    lazy var progressView = makeProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension SCFlashcardsCell {
    func setup(flashcards: SCEFlashcards) {
        progressView.progress = Float(flashcards.topicsLearned) / Float(flashcards.topicsToLearn)
        
        topicsToLearnCountLabel.attributedText = String(flashcards.topicsToLearn)
            .attributed(with: TextAttributes()
                            .font(Fonts.Lato.bold(size: 36.scale))
                            .lineHeight(43.2.scale)
                            .textColor(UIColor(integralRed: 68, green: 68, blue: 68)))
        
        topicsLearnedCountLabel.attributedText = String(flashcards.topicsLearned)
            .attributed(with: TextAttributes()
                            .font(Fonts.Lato.bold(size: 36.scale))
                            .lineHeight(43.2.scale)
                            .textColor(UIColor(integralRed: 68, green: 68, blue: 68)))
    }
}

// MARK: Private
private extension SCFlashcardsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
        
        titleLabel.attributedText = "Study.Flashcards.Title".localized
            .attributed(with: TextAttributes()
                            .font(Fonts.Lato.bold(size: 18.scale))
                            .lineHeight(25.2.scale)
                            .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
                            .letterSpacing(0.3.scale))
        
        topicsToLearnTitleLabel.attributedText = "Study.Flashcards.TopicsToLearn".localized
            .attributed(with: TextAttributes()
                            .font(Fonts.Lato.regular(size: 14.scale))
                            .lineHeight(19.6.scale)
                            .textColor(UIColor(integralRed: 68, green: 68, blue: 68)))
        
        topicsLearnedTitleLabel.attributedText = "Study.Flashcards.TopicsLearned".localized
            .attributed(with: TextAttributes()
                            .font(Fonts.Lato.regular(size: 14.scale))
                            .lineHeight(19.6.scale)
                            .textColor(UIColor(integralRed: 68, green: 68, blue: 68)))
    }
}

// MARK: Make constraints
private extension SCFlashcardsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            topicsToLearnCountLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            topicsToLearnCountLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 49.scale)
        ])
        
        NSLayoutConstraint.activate([
            topicsToLearnTitleLabel.leadingAnchor.constraint(equalTo: topicsToLearnCountLabel.trailingAnchor, constant: 6.scale),
            topicsToLearnTitleLabel.centerYAnchor.constraint(equalTo: topicsToLearnCountLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topicsLearnedTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20.scale),
            topicsLearnedTitleLabel.centerYAnchor.constraint(equalTo: topicsLearnedCountLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topicsLearnedCountLabel.trailingAnchor.constraint(equalTo: topicsLearnedTitleLabel.leadingAnchor, constant: -6.scale),
            topicsLearnedCountLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 49.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            progressView.heightAnchor.constraint(equalToConstant: 13.scale),
            progressView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SCFlashcardsCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 6.scale
        view.layer.masksToBounds = true
        view.trackTintColor = UIColor(integralRed: 250, green: 220, blue: 153)
        view.progressTintColor = UIColor(integralRed: 41, green: 55, blue: 137)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
