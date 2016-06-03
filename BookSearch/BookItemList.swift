//
//  BookItemList.swift
//  BookSearch
//
//  Created by Stuart on 3/06/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import Foundation
import UIKit

class BookItemList {
    class var sharedInstance : BookItemList {
        struct Static {
            static let instance : BookItemList = BookItemList()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "todoItems"
    
    
    func addItem(item: BookItem) {
        var bookDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary()
        bookDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID]
        NSUserDefaults.standardUserDefaults().setObject(bookDictionary, forKey: ITEMS_KEY)
        let notification = UILocalNotification()
        notification.alertBody = "Time to return \"\(item.title)\"!"
        notification.alertAction = "open"
        notification.fireDate = item.deadline
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": item.UUID, ]
        notification.category = "BOOK_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
//    func allItems() -> [BookItem] {
//        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
//        let items = Array(todoDictionary.values)
//        return items.map({BookItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)}).sortInPlace({(this: BookItem, that:BookItem) -> Bool in
//            (this.deadline.compare(that.deadline) == .OrderedAscending)
//        
//
//        })
//    }
    
//    func removeItem(item: BookItem) {
//        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
//            if (notification.userInfo!["UUID"] as! String == item.UUID) {
//                UIApplication.sharedApplication().cancelLocalNotification(notification)
//                break
//            }
//        }
//        
//        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
//            todoItems.removeValueForKey(item.UUID)
//            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY)
//        }
//    }
    
}