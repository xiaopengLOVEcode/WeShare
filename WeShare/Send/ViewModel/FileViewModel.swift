//
//  FileViewModel.swift
//  WeShare
//
//  Created by XP on 2023/12/13.
//

import Foundation

struct FileResourceModel {
    var filePath: URL
    var isSelected: Bool
}

final class FileViewModel {
    var fileModels: [FileResourceModel] = []  // 暂存路径 等选择的时候然后转成Data
    
    // 获取文件名称
    func getFilesName() -> [String] {
        return fileModels.map { $0.filePath.lastPathComponent }
    }
    
    func selectResources() -> [URL] {
        return fileModels.filter { $0.isSelected }.map { $0.filePath }
    }
    
    func selectedAll() {
        fileModels = fileModels.map { var newModel = $0; newModel.isSelected = true; return newModel }
    }
    
    func selectedItem(with index: Int, isSelected: Bool) {
        fileModels[index].isSelected = isSelected
    }
}
