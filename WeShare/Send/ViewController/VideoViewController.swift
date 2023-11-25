//
//  VideoViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import UIKit
import RxSwift
import TZImagePickerController

protocol VideoViewControllerDelegate: SubCommProtocol {
    func videoViewControllerSend()
}

class VideoViewController: UIViewController {
    
    weak var delegate: VideoViewControllerDelegate?
    
    private let vm = VideoViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = .zero
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
    
    private let bag = DisposeBag()
    
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
    
    private func addHandleEvent() {
        bottomBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.videoViewControllerSend()
        }.disposed(by: bag)
    }

    
    private func configPhotoResource() {
        if !TZImageManager.default().authorizationStatusAuthorized() {
            return
        }
        TZImagePickerConfig.sharedInstance().allowPickingImage = true
        TZImagePickerConfig.sharedInstance().allowPickingVideo = true
        TZImageManager.default().pickerDelegate = self
        DispatchQueue.global(qos: .default).async {
            TZImageManager.default().getAllAlbums(withFetchAssets: true) { models in
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


extension VideoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        cell.photoSelImage = UIImage(named: "selected")
        cell.photoSelImage = UIImage(named: "unselected")
        cell.model = vm.dataList[indexPath.section].bumModel.models[indexPath.row] as! TZAssetModel
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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

extension VideoViewController: PhotoSelectedHeaderDelegate {
    func didSelectAllCommentActionCell(section: Int) {
        let isSelected = !vm.currentSectionSelectedAll(section)
    }
    
    func didSelectCommentActionCell(section: Int) {
        let isExpand = !vm.currentSectionState(section)
        vm.updateSectionState(section: section, isExpand: isExpand)
        if isExpand {
            collectionView.performBatchUpdates { [weak self] in
                guard let self = self else { return }
                if let indexPaths = self.vm.indexPathsForSubSection(section: section, loadingCount: 0) {
                    self.collectionView.insertItems(at: indexPaths)
                }
            }
        } else {
            collectionView.performBatchUpdates { [weak self] in
                guard let self = self else {
                    return
                }
                if let indexPaths = self.vm.indexPathsForSubSection(section: section, loadingCount: 0) {
                    self.collectionView.deleteItems(at: indexPaths)
                }
            }
        }
    }
}

extension VideoViewController: TZImagePickerControllerDelegate  {
    func isAlbumCanSelect(_ albumName: String!, result: PHFetchResult<AnyObject>!) -> Bool {
//        if albumName == "视频" {
//            return true
//        }
        return true
    }
}

