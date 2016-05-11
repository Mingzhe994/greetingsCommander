//
//  BookDataModel.swift
//  BookSearch
//
//  Created by Stuart on 11/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BookDataModel{
    
    let context:NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }

    /*
     
     Create a new book (pass this function new clipping details: ie an image and notes string)
     
     */
    
    func createNewBook(bookID : NSNumber, bookTitle: String, bookSubTitle: String,publishYear: String,imagePath: String, bookDescription :String ,authorName :String) -> Bool{
                
        let newBook: BookDetail = NSEntityDescription.insertNewObjectForEntityForName("BookDetail", inManagedObjectContext: context) as! BookDetail
                
        newBook.bookID = bookID
        print(newBook.bookID)
        newBook.bookTitle = bookTitle
        newBook.bookSubTitle = bookSubTitle
        newBook.publishYear = publishYear
        newBook.imagePath = imagePath
        newBook.bookDescription = bookDescription
        newBook.authorName = authorName
                
        return true
    }


    /*
     Delete a Clipping
     */
    
    func deleteAClipping(searchbookID: NSInteger) -> Bool{
        let fetchRequest = NSFetchRequest(entityName: "BookDetail")

        fetchRequest.predicate = NSPredicate(format: "bookID == %@", NSNumber(int: Int32(searchbookID)))
        
        do {
            let fetchedPeople: [BookDetail] = try context.executeFetchRequest(fetchRequest) as! [BookDetail]
            
            for collection in fetchedPeople{
                context.deleteObject(collection)
            }
            return true
        } catch {
            print("Error in the fetch")
            return false
        }
    }
    
    /*
     Search function: Get all clippings whos notes attribute contains a provided search string (pass in a
     search string, return an array of Clippings). Make this search case insensitive. iOS: you must use
     NSPredicate for this.
     
     */
    func searchFunction(searchString: String) -> [BookDetail]{
        let fetchRequest = NSFetchRequest(entityName: "BookDetail")
        
        if searchString != ""{
            
            fetchRequest.predicate = NSPredicate(format: "bookID == %@", NSNumber(integer: Int(searchString)!))
            
        }
        
        do {
            var fetchedCones: [BookDetail] = try context.executeFetchRequest(fetchRequest) as! [BookDetail]
            fetchedCones.sortInPlace({ (book1, book2) -> Bool in
                book1.bookTitle < book2.bookTitle
            })
            return fetchedCones
        } catch {
            print("Error in the fetch")
        }
        return []
    }
    

}