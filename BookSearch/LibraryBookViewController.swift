//
//  LibraryBookViewController.swift
//  BookSearch
//
//  Created by Stuart on 21/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation
import Kanna

class LibraryBookViewController: UIViewController{

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        // Do any additional setup after loading the view, typically from a nib.
        let apiBaseURL = "https://iii.library.uow.edu.au/patroninfo"
        let urlComponents = NSURLComponents(string: apiBaseURL)!
        
        let name = userNameTextField.text
        let code = passwordTextField.text
        
        
        let numQuery: NSURLQueryItem = NSURLQueryItem(name: "name", value: name)
        let rndQuery: NSURLQueryItem = NSURLQueryItem(name: "code", value: code)
        
        urlComponents.queryItems = [numQuery, rndQuery]
        let url = urlComponents.URL!
        
        let request = NSMutableURLRequest(URL: url)
        
        //request.HTTPMethod = "GET"
        request.timeoutInterval = 5
        request.HTTPMethod = "Get"
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request){
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
                
                let resultString:String = NSString(data: d, encoding:NSUTF8StringEncoding)! as String
                //print(resultString)
                    
                //You MUST perform UI updates on the main thread:
                dispatch_async(dispatch_get_main_queue(), {
                    
                        self.getBorrowIngBookList(resultString)
                        self.performSegueWithIdentifier("showBorrowingBooks", sender: self)
                    
                })
                return
            }
                
        }
            
        }
        //This is important
        task.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func errorInput(){
        let loginError = UIAlertController(title: "", message: "Sorry, the information you submitted was invalid. Please try again.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Done", style: .Cancel, handler: nil)
        
        loginError.addAction(cancelAction)
        self.presentViewController(loginError, animated: true, completion: nil)
    }
    
    /*
    func getHtmlString(String url) -> String {
        return ""
    }
     */
    
   // func loginUniAccount() -> String {
     //   <#function body#>
    //}

    
    //check the string if has two keywords inside
    func findKeyWords(origin: String, keyWords1 :String, keyWords2 :String) -> Bool {
        if (origin.rangeOfString(keyWords1) != nil) {
            if (origin.rangeOfString(keyWords2) != nil){
                return true;
            }
        }
        return false;
    }
 
    //this method are only fetch the number string in html like
    //a href="/patroninfo/1265222/items"
    
    func fetchPageNumber(origin: String) -> String {
        var tmp = String()
        var startFectch = 0;
        for c in origin.characters{
            
            if(c == "/"){
                startFectch += 1
            }
            
            if startFectch == 2 && c != "/"{
                tmp += String(c)
            }
        }
        return tmp
    }
    
    
    //get borrowing book list
    func getBorrowIngBookList(origin: String)  {
        //self.label.text = resultString
        var bookList = [String: String]()
        var keyLink = String()
        var errorCheck = false
        let doc = Kanna.HTML(html: origin, encoding: NSUTF8StringEncoding)
        if doc != nil{
            
            for link in doc!.css("p, Strong") {
                
                if link.text!.rangeOfString("Sorry, the information you submitted was invalid. Please try again.") != nil {
                    print(link.text)
                    errorCheck = true
                }
            }
        }
        
        if errorCheck{
            errorInput();
        }else{
            
            for link in doc!.xpath("//a | //href"){
                    
                if findKeyWords(link.toHTML!, keyWords1: "patroninfo", keyWords2: "items"){
                    keyLink = fetchPageNumber(link.toHTML!)
                        //print(keyLink)
                }
            }
        }
        
        let checkOutUrl = "https://iii.library.uow.edu.au/patroninfo/\(keyLink)/items"

        let urlComponents = NSURL(string: checkOutUrl)
        
        let request = NSMutableURLRequest(URL: urlComponents!)
        //request.HTTPMethod = "GET"
        request.timeoutInterval = 5
        request.HTTPMethod = "Get"
        
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
                
                let resultString:String = NSString(data: d, encoding:NSUTF8StringEncoding)! as String
                
                //perform the cast:
                print(r.statusCode)
                
                if (r.statusCode == 200){
                    print("It worked")
                    
                    
                    print(resultString)
                    //print(arrayOfAuthors)
                    
                    //You MUST perform UI updates on the main thread:
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    })
                    
                    
                    
                    return
                }
                
            }
            
        }
        
        //This is important
        task.resume()

        
        //-> [String: String]
        //return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailFromStore" {
            let nav = segue.destinationViewController as! LibraryBookTableViewController
        }
    }
}