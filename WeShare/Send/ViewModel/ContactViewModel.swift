//
//  ContactViewModel.swift
//  WeShare
//
//  Created by XP on 2023/11/21.
//

import Foundation
import Contacts

final class ContactViewModel {
    /// 所有联系人信息的字典
    var addressBookSouce: [String: [PPPersonModel]] = [:]
    /// 所有分组的key值
    var keysArray: [String] = []

    func rowCountFor(section: Int) -> Int {
        let realKey = keysArray[section]
        var result = 0
        addressBookSouce.keys.enumerated().forEach { _, key in
            if let array = addressBookSouce[key], key == realKey {
                let count = array.count
                result = count
            }
        }
        return result
    }

    func selectedAll(with all: Bool) {
        addressBookSouce = addressBookSouce.mapValues { models in
            models.map { model in
                var modifiedModel = model
                modifiedModel.isSelected = all
                return modifiedModel
            }
        }
    }

    func selected(indexPath: IndexPath, isSelected: Bool) {
        let realKey = keysArray[indexPath.section]
        addressBookSouce[realKey]![indexPath.row].isSelected = isSelected
    }

    func sectioNameFor(section: Int) -> String {
        return keysArray[section]
    }

    func modelFor(indexPath: IndexPath) -> PPPersonModel? {
        var model: PPPersonModel?
        let realKey = keysArray[indexPath.section]

        addressBookSouce.keys.enumerated().forEach { _, key in
            if let array = addressBookSouce[key], key == realKey {
                model = array[indexPath.row]
            }
        }
        return model
    }

    func selectResources() -> [PPPersonModel] {
        return addressBookSouce.values.flatMap { $0.filter { $0.isSelected == true } }
    }


}
