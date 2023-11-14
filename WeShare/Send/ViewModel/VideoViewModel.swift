//
//  VideoViewModel.swift
//  WeShare
//
//  Created by XP on 2023/11/12.
//

import Foundation

final class VideoViewModel {
    var dataList: [PhotoGroupModel] = [
        PhotoGroupModel(title: "group1", isExpand: false, isSelectedAll: false),
        PhotoGroupModel(title: "group2", isExpand: false, isSelectedAll: false),
        PhotoGroupModel(title: "group3", isExpand: false, isSelectedAll: false),
        PhotoGroupModel(title: "group4", isExpand: false, isSelectedAll: false),
        PhotoGroupModel(title: "group5", isExpand: false, isSelectedAll: false)
    ]
    
    func indexPathsForSubSection(section: Int, loadingCount: Int) -> [IndexPath]? {
        var indexPaths = [IndexPath]()
        let startIndex = 0
        let endIndex = 11
        for index in startIndex...endIndex {
            let idxPth = NSIndexPath(row: index, section: section)
            indexPaths.append(idxPth as IndexPath)
        }
        return indexPaths
    }
    
    func itemCount(section: Int) -> Int {
        if dataList[section].isExpand {
            return 12
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
}
