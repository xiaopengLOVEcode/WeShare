//
//  FileViewModel.swift
//  WeShare
//
//  Created by XP on 2023/12/13.
//

import Foundation

struct FileResourceModel {
    var filePath: URL
    var selected: Bool
}

final class FileViewModel {
    var fileModels: [FileResourceModel] = []  // 暂存路径 等选择的时候然后转成Data
    
    // 获取文件名称
    func getFilesName() -> [String] {
        return fileModels.map { $0.filePath.lastPathComponent }
    }
}
