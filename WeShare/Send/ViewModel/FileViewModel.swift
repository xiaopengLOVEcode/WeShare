//
//  FileViewModel.swift
//  WeShare
//
//  Created by XP on 2023/12/13.
//

import Foundation

struct FileResourceModel {
    var fileName: String
    var filePath: URL
    var isSelected: Bool
}

struct FileWrapper: Codable {
    var fileName: String
    var data: Data
}

final class FileViewModel {
    var fileModels: [FileResourceModel] = []  // 暂存路径 等选择的时候然后转成Data
    
    // 获取文件名称
    func getFilesName() -> [String] {
        return fileModels.map { $0.filePath.lastPathComponent }
    }
    
    func selectResources() -> [FileResourceModel] {
        return fileModels.filter { $0.isSelected }
    }
    
    func selectedAll() {
        fileModels = fileModels.map { var newModel = $0; newModel.isSelected = true; return newModel }
    }
    
    func selectedItem(with index: Int, isSelected: Bool) {
        fileModels[index].isSelected = isSelected
    }
}
