//
//  SCModesCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 15.04.2021.
//

import UIKit

class SCModesCell: UICollectionViewCell {
    
    private lazy var todayView = makeModeVew()
    private lazy var tenView = makeModeVew()
    private lazy var missedView = makeModeVew()
    private lazy var randomView = makeModeVew()
    
    var selectedMode: ((SCEMode.Mode) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SCModesCell {
    func setup(activeSubscription: Bool) {
        let message = activeSubscription ? nil : "Study.Mode.TryMe".localized
        
        todayView.setup(name: "Study.Mode.TodaysQuestion".localized, image: UIImage(named: "Study.Mode.Todays"), markMessage: message)
        randomView.setup(name: "Study.Mode.RandomSet".localized, image: UIImage(named: "Study.Mode.Random"))
        tenView.setup(name: "Study.Mode.TenQuestions".localized, image: UIImage(named: "Study.Mode.Ten"))
        missedView.setup(name: "Study.Mode.MissedQuestions".localized, image: UIImage(named: "Study.Mode.Missed"))
    }
}

// MARK: Private
private extension SCModesCell {
    func initialize() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    @objc func didSelectMode(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? SCModeView else { return }
        
        if view === tenView {
            selectedMode?(.ten)
        } else if view === todayView {
            selectedMode?(.today)
        } else if view === randomView {
            selectedMode?(.random)
        } else if view === missedView {
            selectedMode?(.missed)
        }
    }
}

// MARK: Make constraints
private extension SCModesCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            todayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            todayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            todayView.widthAnchor.constraint(equalTo: randomView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            randomView.topAnchor.constraint(equalTo: todayView.bottomAnchor, constant: 16.scale),
            randomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            randomView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            randomView.trailingAnchor.constraint(equalTo: todayView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tenView.leadingAnchor.constraint(equalTo: todayView.trailingAnchor, constant: 16.scale),
            tenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tenView.widthAnchor.constraint(equalTo: todayView.widthAnchor, multiplier: 0.95)
        ])
        
        NSLayoutConstraint.activate([
            missedView.topAnchor.constraint(equalTo: tenView.bottomAnchor, constant: 16.scale),
            missedView.leadingAnchor.constraint(equalTo: randomView.trailingAnchor, constant: 16.scale),
            missedView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -6.scale),
            missedView.heightAnchor.constraint(equalTo: tenView.heightAnchor),
            missedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            missedView.widthAnchor.constraint(equalTo: tenView.widthAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SCModesCell {
    func makeModeVew() -> SCModeView {
        let view = SCModeView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectMode))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = UIColor(integralRed: 232, green: 234, blue: 237)
        contentView.addSubview(view)
        return view
    }
}
