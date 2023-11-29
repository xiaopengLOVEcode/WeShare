//
//  VideoViewModel.swift
//  WeShare
//
//  Created by XP on 2023/11/12.
//

import Foundation
import TZImagePickerController

final class VideoViewModel {
    
    var dataList: [PhotoItemGroupModel] = []
    
    func indexPathsForSubSection(section: Int, loadingCount: Int) -> [IndexPath]? {
        var indexPaths = [IndexPath]()
        let startIndex = 0
        let endIndex = dataList[section].bumModel.count - 1
        for index in startIndex...endIndex {
            let idxPth = NSIndexPath(row: index, section: section)
            indexPaths.append(idxPth as IndexPath)
        }
        return indexPaths
    }
    
    func itemCount(section: Int) -> Int {
        if dataList[section].isExpand {
            return dataList[section].bumModel.count
        }
        return 0
    }
    
    func updateSectionState(section: Int, isExpand: Bool) {
        dataList[section].isExpand = isExpand
    }
    
    func currentSectionState(_ section: Int) -> Bool {
        return dataList[section].isExpand
    }
    
    func currentSectionSelectedAll(_ section: Int) -> Bool {
        return dataList[section].isSelectedAll
    }
    
    func selectedAllPhotoModel(with section: Int) {
        let isSelectedAll = !dataList[section].isSelectedAll
        
        dataList[section].bumModel.models.forEach { photoResource in
            guard let model = photoResource as? TZAssetModel else { return }
            model.isSelected = isSelectedAll
        }
        dataList[section].isSelectedAll = isSelectedAll
    }
}
