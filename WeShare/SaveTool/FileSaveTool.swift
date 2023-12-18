//
//  FileSaveTool.swift
//  WeShare
//
//  Created by XP on 2023/12/15.
//

import Foundation

final class FileSaveTool {
    static func saveFileToDocumentsDirectory(with data: Data) {
        let fileWrapper = try? JSONDecoder().decode(FileWrapper.self, from: data)
        guard let tempFile = fileWrapper else { return }
        // 获取文档目录的路径
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // 在文档目录下创建文件路径
            let fileURL = documentsDirectory.appendingPathComponent(tempFile.fileName)
            
            do {
                // 将文件数据写入文件
                try tempFile.data.write(to: fileURL)
                print("文件保存成功，路径：\(fileURL.path)")
            } catch {
                print("保存文件时发生错误：\(error.localizedDescription)")
            }
        }
    }
}
