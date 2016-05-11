//
//  BookDetail+CoreDataProperties.swift
//  BookSearch
//
//  Created by Stuart on 11/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BookDetail {

    @NSManaged var authorName: String?
    @NSManaged var bookDescription: String?
    @NSManaged var bookSubTitle: String?
    @NSManaged var bookTitle: String?
    @NSManaged var imagePath: String?
    @NSManaged var publishYear: String?
    @NSManaged var bookID: NSNumber?

}
