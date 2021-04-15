//
//  CourseCollectionView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import UIKit

typealias CourseElement = (course: Course, isSelected: Bool)

class CourseCollectionView: UICollectionView {
    
    private var elements = [CourseElement]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTapHeader))
        return gesture
    }()
    
    var didTapAdd: (() -> Void)?
    var selectedCourse: ((Course?) -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CourseCollectionView {
    func setup(elements: [CourseElement], isNeedScroll: Bool) {
        self.elements = elements
        CATransaction.setCompletionBlock { [weak self] in
            if isNeedScroll, let index = elements.firstIndex(where: { $0.isSelected }) {
                self?.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: false)
            }
        }
        CATransaction.begin()
        reloadData()
        CATransaction.commit()
    }
}

// MARK: UICollectionViewDelegate
extension CourseCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        return CGSize(width: flowLayout.itemSize.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: 60.scale, height: collectionView.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = visibleCells.first(where: { bounds.contains($0.frame) }) {
            let row = indexPath(for: cell)?.row ?? 0
            selectedCourse?(elements[safe: row]?.course)
        }
    }
}

// MARK: UICollectionViewDataSource
extension CourseCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CourseCell.self), for: indexPath) as! CourseCell
        cell.setup(element: element)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let addHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CourseHeader.self), for: indexPath)
        addHeader.addGestureRecognizer(tapRecognizer)
        return addHeader
    }
}

// MARK: Private
private extension CourseCollectionView {
    func initialize() {
        register(CourseCell.self, forCellWithReuseIdentifier: String(describing: CourseCell.self))
        register(CourseHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CourseHeader.self))
        showsHorizontalScrollIndicator = false
        dataSource = self
        delegate = self
    }
}

private extension CourseCollectionView {
    @objc func didTapHeader() {
        didTapAdd?()
    }
}
