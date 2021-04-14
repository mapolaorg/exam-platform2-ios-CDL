//
//  SCCoursesCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 13.04.2021.
//

import UIKit

class SCCoursesCell: UICollectionViewCell {
    
    private lazy var collectionView = makeCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SCCoursesCell {
    func setup(elements: [CourseElement], selectedCourse: @escaping (Course?) -> Void, didTapAdd: @escaping () -> Void) {
        collectionView.selectedCourse = selectedCourse
        collectionView.didTapAdd = didTapAdd
        collectionView.setup(elements: elements)
    }
}

// MARK: Private
private extension SCCoursesCell {
    func initialize() {
        
    }
}

// MARK: Make constraints
private extension SCCoursesCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32.scale),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SCCoursesCell {
    func makeCollectionView() -> CourseCollectionView {
        let layout = CourseFlowLayout()
        layout.itemSize = CGSize(width: 237.scale, height: .zero)
        let view = CourseCollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        contentView.addSubview(view)
        return view
    }
}
