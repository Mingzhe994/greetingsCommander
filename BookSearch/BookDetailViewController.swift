//
//  BookDetailViewController.swift
//  BookSearch
//
//  Created by Stuart on 10/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class BookDetailViewController:UIViewController  {
    var receiveISBN:String = ""
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    //var newBook = BookDetail()
    var myBookList: BookDataModel?
    var recieveBookID:NSInteger?
    var imagelinks: [String]?
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthorName: UITextView!
    @IBOutlet weak var bookSubTitle: UILabel!
    @IBOutlet weak var publishYear: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ISBNcode = receiveISBN
         
        myBookList = BookDataModel(context: managedObjectContext)
        
        self.title = "Book detail"
        
        if ISBNcode == ""{
            let searchID = String(recieveBookID!)
            let bookDetail = myBookList?.searchFunction(searchID)
            
            let tmp = bookDetail![0]
            bookTitle.text = tmp.bookTitle
            bookSubTitle.text = tmp.bookSubTitle
            publishYear.text = tmp.publishYear
            bookDescription.text = tmp.bookDescription
            bookAuthorName.text = tmp.authorName
            
            if tmp.imagePath != "noData"{
                let fileUrl = NSURL(string: tmp.imagePath!)
                bookImageView.sd_setImageWithURL(fileUrl)
            }else{
                bookImageView.image = UIImage(named: tmp.imagePath!)
            }
            
            
        }else{
            let backButton : UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BookDetailViewController.backToRootView))
            
            self.navigationItem.leftBarButtonItem = backButton
            

            self.getBookInfo(ISBNcode) 
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getBookInfo(isbn: String){

        let apiBaseURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        let urlComponents = NSURL(string: apiBaseURL)
        
        //let url = urlComponents.URL!
        //let request = NSMutableURLRequest(URL: urlComponents!)

        if Reachability.isConnectedToNetwork() == true {
            print(urlComponents)
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(urlComponents!){
                (data, response, error) -> Void in
                
                //Something stuffed up:
                if let e = error  {
                    
                    print("error")
                    print(e.localizedDescription)
                    
                    return
                    
                    //Check for issues with the status code:
                } else if let d = data, let r = response as? NSHTTPURLResponse{
                    
                    
                    //perform the cast:
                    print(r.statusCode)
                    
                    if (r.statusCode == 200){
                        print("It worked")
                        var arrayOfTitles: [String]?
                        var subTitle: [String]?
                        var arrayOfAuthors: [String] = [String]()
                        var publishDate: [String]?
                        var description: [String]?
                        
                        do {
                            let anyObj:NSDictionary = try NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                            // use anyObj here
                            
                            arrayOfTitles = anyObj.valueForKeyPath("items.volumeInfo.title") as? [String] ?? ["No data"]
                            subTitle = anyObj.valueForKeyPath("items.volumeInfo.subtitle") as? [String] ?? ["No data"]
                            
                            let a = anyObj.valueForKeyPath("items.volumeInfo.authors") as? NSArray
                            if a != nil {
                                for tmpa in a! {
                                    let b = tmpa as? NSArray ?? ["No data"]
                                    for tmpb in b!{
                                        arrayOfAuthors.append(tmpb as! String)
                                        
                                    }
                                }
                            }else{
                                arrayOfAuthors.append("No data")
                            }
                            publishDate = anyObj.valueForKeyPath("items.volumeInfo.publishedDate") as? [String] ?? ["No data"]
                            description = anyObj.valueForKeyPath("items.volumeInfo.description") as? [String] ?? ["No data"]
                            
                            self.imagelinks = anyObj.valueForKeyPath("items.volumeInfo.imageLinks.smallThumbnail") as? [String] ?? ["noData"]
                            //self.bookImageView.image = UIImage(
                            //print(imagelinks)
                        } catch let error as NSError {
                            print("json error: \(error.localizedDescription)")
                        }
                        
                        //print(arrayOfAuthors)
                        
                        //You MUST perform UI updates on the main thread:
                        dispatch_async(dispatch_get_main_queue(), {
                            self.bookTitle.text = arrayOfTitles![0]
                            self.bookSubTitle.text = subTitle![0]
                            
                            self.publishYear.text = publishDate![0]
                            self.bookDescription.text = description![0]
                            self.bookAuthorName.text = arrayOfAuthors.joinWithSeparator("\n")
                            
                            if self.imagelinks![0] != "noData"{
                                let imageURL = NSURL(string: self.imagelinks![0])
                                self.bookImageView.sd_setImageWithURL(imageURL)
                            }else{
                                self.bookImageView.image = UIImage(named: self.imagelinks![0])
                            }
                        })
                        
                        
                        
                        return
                    }
                    
                }
                
            }
            let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BookDetailViewController.saveBookDetail))
            
            self.navigationItem.rightBarButtonItem = saveButton
            
            //This is important
            task.resume()
            
            
            
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Done", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func saveBookDetail(tmpBook: BookDetail){
        //myBookList?.createNewBook(tmpBook)
        let tmp  = myBookList?.searchFunction("")
        let ID = (tmp?.count)! + 1
        let title = bookTitle.text
        let subTitle = bookSubTitle.text
        let year = publishYear.text
        let path = imagelinks![0]
        let description = bookDescription.text
        let aName = bookAuthorName.text
        
        myBookList?.createNewBook(ID, bookTitle: title!, bookSubTitle: subTitle!, publishYear: year!, imagePath: path, bookDescription: description, authorName: aName)
        
        let createBookList = UIAlertController(title: "", message: "Added a book to your list!", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Done", style: .Cancel, handler: {
            _ in
            self.backToRootView()
        })
        
        createBookList.addAction(cancelAction)
        
        self.presentViewController(createBookList, animated: true, completion: nil)
    }
    
    
    
    func backToRootView(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    

}