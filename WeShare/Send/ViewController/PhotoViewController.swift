//
//  PhotoViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import RxCocoa
import RxSwift
import UIKit
import TZImagePickerController

final class PhotoViewController: UIViewController, TZImagePickerControllerDelegate {
    
    weak var delegate: CommContentVcDelegate?
    
    private let vm = PhotoViewModel()
    
    private let bag = DisposeBag()
    
    private let picker = TZImageManager()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.footerReferenceSize = .zero
        flowLayout.minimumLineSpacing = 7
        flowLayout.minimumInteritemSpacing = 7
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: LayoutConstants.deviceWidth - 32, height: 40)
        flowLayout.itemSize = CGSize(width: 110, height: 110)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(
            PhotoSelectedHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PhotoSelectedHeader.reuseIdentifier
        )
        
        view.register(TZAssetCell.self, forCellWithReuseIdentifier: "TZAssetCell")
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private let bottomBtn = GradientButton().then {
        $0.applyAriesStyle()
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.setTitle("开始发送", for: .normal)
        $0.setTitle("开始发送", for: .highlighted)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        addHandleEvent()
        configPhotoResource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.showRightBtn(isHidden: true)
    }

    private func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func configPhotoResource() {
        PhotoUtil.requestPhotoLibraryPermission { [weak self] grant in
            guard let self = self else { return }
            if grant {
                self.picker?.pickerDelegate = self
                DispatchQueue.global(qos: .default).async { [weak self] in
                    guard let self = self else { return }
                    self.picker?.getAllAlbums(false, allowPickingImage: true, needFetchAssets: true) { models in
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            let groupMoldels: [PhotoItemGroupModel] = models?.map { PhotoItemGroupModel(bumModel: $0, isExpand: false, isSelectedAll: false) } ?? []
                            self.vm.dataList = groupMoldels
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }

    private func addHandleEvent() {
        bottomBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            let array = self.vm.selectResources()
            if array.isEmpty {
                PLToast.showAutoHideHint("未选中资源")
            } else {
                self.delegate?.contentViewControllerSend(self)
            }
        }.disposed(by: bag)
    }
}

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.itemCount(section: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vm.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TZAssetCell", for: indexPath) as? TZAssetCell else {
            return UICollectionViewCell()
        }
        cell.showSelectBtn = true
        cell.photoDefImage = UIImage(named: "unselected")
        cell.photoSelImage = UIImage(named: "selected")
        let assetModel = vm.dataList[indexPath.section].bumModel.models[indexPath.row]
        cell.model = assetModel
        cell.didSelectPhotoBlock = { [weak cell, weak self] isSelected in
            guard let self = self else { return }
            guard let s_cell = cell else { return }
            self.vm.selectedItem(with: indexPath, isSelected: !isSelected)
            if isSelected {
                s_cell.selectPhotoButton.isSelected = false;
            } else {
                s_cell.selectPhotoButton.isSelected = true;
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section)   \(indexPath.row)")
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PhotoSelectedHeader.reuseIdentifier,
                for: indexPath
            ) as? PhotoSelectedHeader else {
                return UICollectionReusableView()
            }
            header.update(model: vm.dataList[indexPath.section])
            header.section = indexPath.section
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }
}

extension PhotoViewController: PhotoSelectedHeaderDelegate {
    func didSelectAllCommentActionCell(section: Int) {
        vm.selectedAllPhotoModel(with: section)
        collectionView.reloadData()
    }
    
    func didSelectCommentActionCell(section: Int) {
        print("section: %d", section)
        let isExpand = !vm.currentSectionState(section)
        vm.updateSectionState(section: section, isExpand: isExpand)
        if isExpand {
            collectionView.performBatchUpdates { [weak self] in
                guard let self = self else { return }
                if let indexPaths = self.vm.indexPathsForSubSection(section: section) {
                    self.collectionView.insertItems(at: indexPaths)
                }
            } completion: { _ in
                UIView.performWithoutAnimation { [weak self] in
                    self?.collectionView.reloadData()
                }
                
                self.collectionView.reloadData()
            }
        } else {
            collectionView.performBatchUpdates { [weak self] in
                guard let self = self else { return }
                if let indexPaths = self.vm.indexPathsForSubSection(section: section) {
                    self.collectionView.deleteItems(at: indexPaths)
                }
            } completion: { _ in
                UIView.performWithoutAnimation { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}

extension PhotoViewController: TransferTaskManagerDelegate {
    func transferTaskManagerGetDatas() -> [TransferData] {
        return []
    }
}

extension PhotoViewController  {
    func isAlbumCanSelect(_ albumName: String!, result: PHFetchResult<AnyObject>!) -> Bool {
        return true
    }
}

extension PhotoViewController: PageVCProtocol {
    func selectedAll() {}
}
