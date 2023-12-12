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

    func selectedAll() {
        addressBookSouce = addressBookSouce.mapValues { models in
            models.map { model in
                var modifiedModel = model
                modifiedModel.isSelected = true
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

    // 写入联系人
    func addContact(with models: [PPPersonModel]) {
        // 创建通讯录对象
        let store = CNContactStore()
        // 创建CNMutableContact类型的实例
        let contactToAdd = CNMutableContact()
        // 设置姓名
        contactToAdd.familyName = "张"
        contactToAdd.givenName = "飞"
        // 设置昵称
        contactToAdd.nickname = "fly"

        // 设置电话
        let mobileNumber = CNPhoneNumber(stringValue: "18510002000")
        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                         value: mobileNumber)
        contactToAdd.phoneNumbers = [mobileValue]

        
        // 添加联系人请求
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
        do {
            // 写入联系人
            try store.execute(saveRequest)
            print("保存成功!")
        } catch {
            print(error)
        }
    }
}
