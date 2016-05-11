//
//  BookDetailViewController.swift
//  BookSearch
//
//  Created by Stuart on 10/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import Foundation
import UIKit

class BookDetailViewController:UIViewController  {
    var receiveISBN:String = ""
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthorName: UITextView!
    @IBOutlet weak var bookSubTitle: UILabel!
    @IBOutlet weak var publishYear: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ISBNcode = receiveISBN
         
        
        self.title = "Book detail"
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BookDetailViewController.backToRootView))
        
        self.navigationItem.leftBarButtonItem = saveButton
        
        self.getBookInfo(ISBNcode)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getBookInfo(isbn: String){
        /*let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = NSURL(string: urlString) {
            NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, _, error -> Void in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print(url)
                    if let data = data, jsonResult = try? NSJSONSerialization.JSONObjectWithData(data, options: []), arrayOfTitles = jsonResult.valueForKeyPath("items.volumeInfo.title") as? [String] {
                        
                        
                        let titles = arrayOfTitles.joinWithSeparator(", ")
                        
                        print(titles)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                                self.bookTitle.text = titles
                        })

                        //self.bookSubTitle.text = jsonResult.valueForKey("items.volumeInfo.subtitle") as? String
                        
                        //let arrayOfAuthors = jsonResult.valueForKey("items.volumeInfo.authors") as? [String]
                        //self.bookAuthorName.text = arrayOfAuthors?.joinWithSeparator(",")
                        
                        //self.publishYear.text = jsonResult.valueForKey("items.volumeInfo.publishedDate") as? String
                        //self.bookDescription.text = jsonResult.valueForKey("items.volumeInfo.description") as? String
                        
                        //let imagelinks = jsonResult.valueForKey("items.volumeInfo.imageLinks.smallThumbnail") as? String
                        //self.bookImageView.image = UIImage(
                        
                        
                    } else {
                        //GlobalConstants.AlertMessage.displayAlertMessage("Error fetching data from barcode, please try again.", view: self)
                        /*
                        let cannotFindThisBook = UIAlertController(title: "", message: "Sorry I can't get any information of this book T_T", preferredStyle: .Alert)
                        let doneAction = UIAlertAction(title: "Done", style: .Cancel, handler: {(action) in})
                        cannotFindThisBook.addAction(doneAction)
                        self.presentViewController(cannotFindThisBook, animated: true, completion: nil)*/

                    }
                }
            }).resume()
        }
        */
        

        let apiBaseURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        let urlComponents = NSURL(string: apiBaseURL)
        
        //let url = urlComponents.URL!
        //let request = NSMutableURLRequest(URL: urlComponents!)

        
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
                    var imagelinks: [String]?

                    
                    do {
                        let anyObj:NSDictionary = try NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                        // use anyObj here

                        arrayOfTitles = anyObj.valueForKeyPath("items.volumeInfo.title") as? [String] ?? ["No data"]
                        subTitle = anyObj.valueForKeyPath("items.volumeInfo.subtitle") as? [String] ?? ["No data"]
                        
                        let a = anyObj.valueForKeyPath("items.volumeInfo.authors") as? NSArray
                        for tmpa in a! {
                            let b = tmpa as? NSArray ?? ["No data"]
                            for tmpb in b!{
                               arrayOfAuthors.append(tmpb as! String)
                                
                            }
                        }
                        
                        publishDate = anyObj.valueForKeyPath("items.volumeInfo.publishedDate") as? [String] ?? ["No data"]
                        description = anyObj.valueForKeyPath("items.volumeInfo.description") as? [String] ?? ["No data"]
                        
                        imagelinks = anyObj.valueForKeyPath("items.volumeInfo.imageLinks.smallThumbnail") as? [String] ?? ["noData"]
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
                        
                        if imagelinks![0] != "noData"{
                            let imageURL = NSURL(string: imagelinks![0])
                            self.bookImageView.sd_setImageWithURL(imageURL)
                        }else{
                            self.bookImageView.image = UIImage(named: imagelinks![0])
                        }

                    })
                    
                    
                    
                    return
                }
                
            }
            
        }
        //This is important
        task.resume()
        
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