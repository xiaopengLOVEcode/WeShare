//
//  ContactSaveTool.swift
//  WeShare
//
//  Created by XP on 2023/12/15.
//

import Foundation
import Contacts

final class ContactSaveTool {
    // 写入联系人
    static func addContact(with models: [PPPersonModel]) {
        models.forEach { model in
            // 创建通讯录对象
            let store = CNContactStore()
            // 创建CNMutableContact类型的实例
            let contactToAdd = CNMutableContact()
            // 设置姓名
            contactToAdd.familyName = model.name
//            contactToAdd.givenName = "飞"
//            // 设置昵称
//            contactToAdd.nickname = "fly"

            // 设置电话
            var numberArray: [CNLabeledValue<CNPhoneNumber>] = []
            model.mobileArray.forEach { number in
                let mobileNumber = CNPhoneNumber(stringValue: number)
                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,value: mobileNumber)
                numberArray.append(mobileValue)
            }
            contactToAdd.phoneNumbers = numberArray

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
}
