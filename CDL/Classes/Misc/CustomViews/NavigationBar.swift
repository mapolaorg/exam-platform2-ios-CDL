//
//  NavigationBar.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 28.03.2021.
//

import UIKit

class NavigationBar: UIView {
    private let titleLabel = UILabel()
    let rightAction = UIButton()
    let leftAction = UIButton()
    
    private var path: UIBezierPath?
    
    var isBigTitle: Bool = false {
        didSet {
            leftAction.isHidden = isBigTitle
            titleLabel.attributedText = titleLabel.text?.attributed(with: isBigTitle ? .bigAttr : .smallAttr)
            makeTitleConstraint()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return path?.contains(point) ?? true
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height), byRoundingCorners: .bottomLeft, cornerRadii: CGSize(width: 40.scale, height: 40.scale))
        bezierPath.close()
        UIColor.gray.setFill()
        path = bezierPath
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        layer.mask = maskLayer
    }
}

// MARK: API
extension NavigationBar {
    func setTitle(title: String) {
        titleLabel.attributedText = title.attributed(with: isBigTitle ? .bigAttr : .smallAttr)
    }
}

// MARK: Private
private extension NavigationBar {
    func initialize() {
        [titleLabel, leftAction, rightAction].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        clipsToBounds = true
    }
}

// MARK: Make constraints
private extension NavigationBar {
    func makeConstraints() {
        makeTitleConstraint()
        NSLayoutConstraint.activate([
            leftAction.heightAnchor.constraint(equalToConstant: 24.scale),
            leftAction.widthAnchor.constraint(equalTo: leftAction.heightAnchor),
            leftAction.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            leftAction.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightAction.heightAnchor.constraint(equalToConstant: 24.scale),
            rightAction.widthAnchor.constraint(equalTo: rightAction.heightAnchor),
            rightAction.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightAction.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
    
    func makeTitleConstraint() {
        titleLabel.removeFromSuperview()
        addSubview(titleLabel)
        if isBigTitle {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 59.scale),
                titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 22.scale)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 59.scale),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
    }
}

private extension TextAttributes {
    static let smallAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 24.scale))
        .lineHeight(28.8.scale)
        .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
        .textAlignment(.center)
    
    static let bigAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 32.scale))
        .lineHeight(41.scale)
        .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
        .textAlignment(.left)
}
