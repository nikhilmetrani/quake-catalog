//
//  QuakeTableViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 28/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import MapKit

class QuakeTableViewController: UITableViewController, QCURLQueryDelegate {
    
    var detailViewController: QuakeDetailViewController? = nil
    var quakeSearchResultController: QuakeSearchViewController? = nil
    var quakeSearchCriteria: QuakeSearchCriteria = QuakeSearchCriteria()
    
    var currentSearchResult: QCQuakeQueryResult?
    let quakeQueryURLAsString: String = "http://earthquake.usgs.gov/fdsnws/event/1/query"
    var urlQuery: QCURLQuery = QCURLQuery.instance
    var quakeCoordinateAndSpan: (quakeCoordinates: CLLocationCoordinate2D, spanArea: MKCoordinateSpan)?
    
    let dateTimeComponents: QCDateTimeConponents = QCDateTimeConponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "Quakes"
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let buttonRefineSearch = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "refineSearchCriteria:")
        self.navigationItem.rightBarButtonItem = buttonRefineSearch
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? QuakeDetailViewController
        }
        
        urlQuery.URL = quakeQueryURLAsString
        urlQuery.delegate = self
        initializeSearchCriteria()
        urlQuery.createQueryFromSearchCriteria(quakeSearchCriteria)
        
        self.urlQuery.execute()
        tableView.reloadData()
    }
    
    func refineSearchCriteria(sender: AnyObject) {
        //courses.insert(CourseModel(), atIndex: 0)
        //let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        //self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        //CourseModel.selectedCourse = courses[0]
        self.performSegueWithIdentifier("refineSearch", sender: nil)
    }
    
    @IBAction func refineSearchDidReturn(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //tableView.reloadData()
    }
    
    func didReturnSearchResults(quakeSearchResult: QCQuakeQueryResult) {
        currentSearchResult = quakeSearchResult
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let quakeFeature = currentSearchResult!.features[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! QuakeDetailViewController
                controller.selectedQuakeFeature = quakeFeature
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "refineSearch" {
            quakeSearchResultController = segue.destinationViewController as? QuakeSearchViewController
            quakeSearchResultController!.searchCriteria = quakeSearchCriteria
            quakeSearchResultController!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            quakeSearchResultController!.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    func initializeSearchCriteria() {
        let dateTimeComponents: QCDateTimeConponents = QCDateTimeConponents()
        
        quakeSearchCriteria.minmagnitude = 4
        quakeSearchCriteria.maxmagnitude = 4
        quakeSearchCriteria.year = dateTimeComponents.year
        quakeSearchCriteria.month = dateTimeComponents.month
        quakeSearchCriteria.day = dateTimeComponents.day
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nil != currentSearchResult {
            return currentSearchResult!.features.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quakeCell", forIndexPath: indexPath) as! QuakeTableViewCell
        
        let row = indexPath.row
        cell.magnitude?.text = "\(currentSearchResult!.features[row].mag!)"
        cell.place?.text = currentSearchResult!.features[row].place!
        //cell.coordinates?.text = "\(currentSearchResult!.features[row].geometry!.longitude!), \(currentSearchResult!.features[row].geometry!.latitude!)"
        
        let time: Int = (currentSearchResult!.features[row].time! )/1000
        
        let theDate = NSDate(timeIntervalSince1970: NSTimeInterval(time))
   
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        let dateString = formatter.stringFromDate(theDate)
        
        print(dateString)
        cell.coordinates?.text = dateString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }*/

}
