//
//  SearchMasterViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit

class SearchMasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QCURLQueryDelegate {
    
    var urlQuery: QCURLQuery = QCURLQuery.instance
    var currentSearchResult: QCQuakeQueryResult?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableViewQuake: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Quakes"
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        urlQuery.delegate = self
        currentSearchResult = urlQuery.searchResult
        tableViewQuake.separatorStyle = UITableViewCellSeparatorStyle.None
        tableViewQuake.dataSource = self
        tableViewQuake.delegate = self
        tableViewQuake.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableViewQuake.reloadData()
    }
    
    func didReturnSearchResults(quakeSearchResult: QCQuakeQueryResult) {
        currentSearchResult = quakeSearchResult
        tableViewQuake.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nil != currentSearchResult {
            return currentSearchResult!.features.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quakeCell", forIndexPath: indexPath) as! QuakeTableViewCell
        
        let row = indexPath.row
        cell.magnitude?.text = "\(currentSearchResult!.features[row].mag!)"
        cell.place?.text = currentSearchResult!.features[row].place!
        cell.coordinates?.text = "\(currentSearchResult!.features[row].geometry!.longitude!), \(currentSearchResult!.features[row].geometry!.latitude!)"
        
        return cell
    }
    
    @IBAction func backFromDetail(segue: UIStoryboardSegue) {
        
    }
}
