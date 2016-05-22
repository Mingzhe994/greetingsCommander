//
//  BookListTableViewController.swift
//  BookSearch
//
//  Created by Stuart on 11/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import UIKit
import SDWebImage

class BookListTableViewController: UITableViewController,UINavigationControllerDelegate {

    @IBOutlet var myTableView: UITableView!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var myBookModel: BookDataModel?
    var myList:[BookDetail] = [BookDetail]()
    var filteredMyList: [BookDetail] = []
    var searchBarController: UISearchController?
    var sendBookID: NSInteger?

    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMyList = myList.filter{book in
            return (book.bookTitle!.lowercaseString.containsString(searchText.lowercaseString))
        }
        tableView.reloadData()
    }
    
    deinit{//I have not idea why without this will out put error message
        if let superView = searchBarController!.view.superview
        {
            superView.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myBookModel = BookDataModel(context: managedObjectContext)

        
        myList = myBookModel!.searchFunction("")
        
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController!.searchResultsUpdater = self
        searchBarController!.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchBarController!.searchBar

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if searchBarController!.active && searchBarController!.searchBar.text  != ""{
            return filteredMyList.count
        }
        return myList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookIDF", forIndexPath: indexPath) as! BookListTableViewCell

        // Configure the cell...

        let tempClipping: BookDetail
        
        if searchBarController!.active && searchBarController!.searchBar.text != ""{
            tempClipping = filteredMyList[indexPath.row]
        }else{
            tempClipping = myList[indexPath.row]
        }
        
        //Title
        cell.bookTitle.text = tempClipping.bookTitle
        //subTitle
        cell.bookSubtitle.text = tempClipping.bookSubTitle
        
        //image
        
        let fileUrl = NSURL(string: tempClipping.imagePath!)
        
        if tempClipping.imagePath != "noData"{
            
            cell.imageView?.sd_setImageWithURL(fileUrl)
        }else{
            cell.imageView?.image = UIImage(named: tempClipping.imagePath!)
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //remove the data from coredata and collectionArray

            
            myBookModel!.deleteAClipping(myList[indexPath.row].bookID! as NSInteger)
            myList.removeAtIndex(indexPath.row)
            // delete table
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailFromStore" {
            let nav = segue.destinationViewController as! BookDetailViewController
            nav.recieveBookID = sendBookID
        }
    }
    
    
    func refresh(){
        myList = myBookModel!.searchFunction("")
        self.myTableView.reloadData()
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        sendBookID = myList[indexPath.row].bookID as? NSInteger
        self.performSegueWithIdentifier("showDetailFromStore", sender: self)
    }

}

extension BookListTableViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController){
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
