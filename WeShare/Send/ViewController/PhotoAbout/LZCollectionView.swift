//
//  LZCollectionView.swift
//  WeShare
//
//  Created by XP on 2023/11/12.
//

import Foundation
import UIKit

final class LZCollectionView: UIView {
    
    private let dataCount = 12
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 110, height: 110)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(PhotoItemsCell.self, forCellWithReuseIdentifier: PhotoItemsCell.reuseIdentifier)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubViews() {
        
    }
}

extension LZCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemsCell.reuseIdentifier, for: indexPath) as? PhotoItemsCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
