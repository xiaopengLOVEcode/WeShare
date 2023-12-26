//
//  BannerView.swift
//  geekTime
//
//  Created by zhj on 2019/11/23.
//  Copyright © 2019 geekbang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol BannerViewDataSource: AnyObject {
    func dataOfBanners(_ bannerView: BannerView) -> [GuideModel]
}

final class BannerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let bannerWidth = LayoutConstants.deviceWidth
    
    static let bannerHeight = LayoutConstants.deviceHeight * (448 / 812)
    
    weak var dataSource: BannerViewDataSource! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: Self.bannerWidth, height: CGFloat(Self.bannerHeight))
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isPagingEnabled = true
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        view.backgroundColor = .white
        view.isScrollEnabled = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    static var cellId = "bannerViewCellId"
    static var convertViewTag = 10086
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pageNumber = dataSource.dataOfBanners(self).count
        return pageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as? BannerCell else {
            return UICollectionViewCell()
        }
        
        let pageNumber = dataSource.dataOfBanners(self).count
        var index = indexPath.row
        if pageNumber > 1 {
            if indexPath.row == 0 {
                index = pageNumber - 1
            } else if indexPath.row == pageNumber + 1 {
                index = 0
            } else {
                index = indexPath.row - 1
            }
        }
        
        let model = dataSource.dataOfBanners(self)[safe: index]
        cell.bind(with: model!)
        return cell
    }
    
    func flipNext() {
        let totalPageNumber = dataSource.dataOfBanners(self).count
        guard totalPageNumber > 1 else {
            return
        }
        let currentPageNumber = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        let nextPageNumber = currentPageNumber + 1
        collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(nextPageNumber), y: 0), animated: true)
    }
}


