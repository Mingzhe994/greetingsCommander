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

class LibraryBookViewController: UIViewController{
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log In"
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let apiBaseURL = "https://iii.library.uow.edu.au/patroninfo"
        let urlComponents = NSURLComponents(string: apiBaseURL)!
        
        let numQuery: NSURLQueryItem = NSURLQueryItem(name: "name", value: "Mingzhe Zhang")
        let rndQuery: NSURLQueryItem = NSURLQueryItem(name: "code", value:"100")
        
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
                    
                    print("RESULT IS:")
                    print(resultString)
                    
                    //You MUST perform UI updates on the main thread:
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.label.text = resultString
                    })
                    
                    
                    
                    return
                }
                
            }
            
        }
        //This is important
        task.resume()
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}