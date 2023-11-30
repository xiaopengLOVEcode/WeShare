//
//  ContactViewModel.swift
//  WeShare
//
//  Created by XP on 2023/11/21.
//

import Foundation

final class ContactViewModel {
    /// 所有联系人信息的字典
    var addressBookSouce: [String: [PPPersonModel]] = [:]
    /// 所有分组的key值
    var keysArray: [String] = []
    
    func rowCountFor(section: Int) -> Int {
        var result = 0
        addressBookSouce.keys.enumerated().forEach { (index, key) in
            if let array = addressBookSouce[key], index == section {
                let count = array.count
                result = count
            }
        }
        return result
    }
    
    func selectedAll() {
        
    }
    
    func sectioNameFor(section: Int) -> String {
        var sectionName = ""
        addressBookSouce.keys.enumerated().forEach { (index, key) in
            if index == section {
                sectionName = key
            }
        }
        return sectionName
    }
    
    func modelFor(indexPath: IndexPath) -> PPPersonModel? {
        var model: PPPersonModel?
        addressBookSouce.keys.enumerated().forEach { (index, key) in
            if let array = addressBookSouce[key], index == indexPath.section {
                model = array[indexPath.row]
            }
        }
        return model
    }
}
