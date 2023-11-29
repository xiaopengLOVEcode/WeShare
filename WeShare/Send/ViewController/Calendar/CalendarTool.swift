//
//  CalendarTool.swift
//  WeShare
//
//  Created by XP on 2023/11/22.
//

import EventKit

class CalendarManager {
    private let eventStore = EKEventStore()

    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .reminder) { granted, _ in
            completion(granted)
        }
    }

    func fetchReminders(completion: @escaping ([EKReminder]?) -> Void) {
        let calendars = eventStore.calendars(for: .reminder)
        let predicate = eventStore.predicateForReminders(in: calendars)
        eventStore.fetchReminders(matching: predicate) { reminders in
            completion(reminders)
        }
    }
    
    // https://developer.aliyun.com/article/932459  日历用法
    static func selectReminder(remindersClosure: @escaping (([EKReminder]?) -> Void)) {
        // 在取得提醒之前，需要先获取授权
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) {
            (granted: Bool, error: Error?) in
            if granted && (error == nil) {
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = eventStore.predicateForReminders(in: nil)
                eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) in
                    DispatchQueue.main.async {
                        remindersClosure(reminders)
                    }
                })
            } else {
                DispatchQueue.main.async {
                    remindersClosure(nil)
                }
            }
        }
    }
    
//    static func addReminder(title: String, startDate: Date, endDate: Date, notes: String, eventsClosure: @escaping ((Bool, String?) -> Void)) {
//        let eventStore = EKEventStore()
//        // 获取"提醒"的访问授权
//        eventStore.requestAccess(to: .reminder) {(granted, error) in
//            if (granted) && (error == nil) {
//                // 创建提醒条目
//                let reminder = EKReminder(eventStore: eventStore)
//                reminder.title = title
//                reminder.notes = notes
//                reminder.startDateComponents = dateComponentFrom(date: startDate)
//                reminder.dueDateComponents = dateComponentFrom(date: endDate)
//                reminder.calendar = eventStore.defaultCalendarForNewReminders()
//                // 保存提醒事项
//                do {
//                    try eventStore.save(reminder, commit: true)
//                    DispatchQueue.main.async {
//                        eventsClosure(true, reminder.calendarItemIdentifier)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        eventsClosure(false, nil)
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    eventsClosure(false, nil)
//                }
//            }
//        }
//    }
}

//// 示例用法
// let calendarManager = CalendarManager()
//
// calendarManager.requestCalendarAccess { granted in
//    if granted {
//        calendarManager.fetchReminders { reminders in
//            if let reminders = reminders {
//                for reminder in reminders {
//                    print("Title: \(reminder.title), Due Date: \(reminder.dueDateComponents?.date ?? Date())")
//                }
//            }
//        }
//    } else {
//        print("Calendar access not granted.")
//    }
// }
