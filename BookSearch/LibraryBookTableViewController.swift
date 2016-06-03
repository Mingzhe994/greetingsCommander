//
//  LibraryBookTableViewController.swift
//  BookSearch
//
//  Created by Stuart on 21/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import UIKit

class LibraryBookTableViewController: UITableViewController {
    var receiveBookList: [String]?
    var receiveNameChange: Bool?
    
    override func viewDidLoad() {
        self.title = "Checkout List"
        
        let backButton : UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BookDetailViewController.backToRootView))
        
        self.navigationItem.leftBarButtonItem = backButton
        
        //if user have no borrowing data
        if receiveBookList?.count == 0{
            receiveBookList?.append("There is no book need to return")
            receiveBookList?.append("")
        }else {
            print("Get books Detail!")
            let countLimit = (((receiveBookList?.count)!/2)-1 )
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            for i in 0...countLimit {
                
                let strDate = receiveBookList![i*2+1]
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yy"
                print(dateFormatter.dateFromString( strDate )!)
                
                let todoItem =  BookItem(deadline:  dateFormatter.dateFromString( strDate )! , title: receiveBookList![i*2], UUID: NSUUID().UUIDString)
                BookItemList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            }
            
        }
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (receiveBookList?.count)!/2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("libraryList", forIndexPath: indexPath) as! LibraryBookListTableViewCell
        
        // Configure the cell...
        let title = receiveBookList![indexPath.row*2]
        let dueDate = receiveBookList![indexPath.row*2 + 1 ]
        
        cell.bookTitle.text = title
        cell.date.text = dueDate
        
        
        return cell
    }
 
    
    func backToRootView(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}
