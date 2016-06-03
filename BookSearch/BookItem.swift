//
//  BookItem.swift
//  BookSearch
//
//  Created by Stuart on 3/06/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import Foundation

struct BookItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    
    init(deadline: NSDate, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending)
    }
}