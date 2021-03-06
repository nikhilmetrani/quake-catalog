//
//  AuthViewController.swift
//  SwifterDemoiOS
//
//  Copyright (c) 2014 Matt Donnelly.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import Accounts
import Social
import SwifteriOS
import SafariServices

class AuthViewController: UIViewController, SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var swifter: Swifter
    @IBOutlet var tableView: UITableView!
    // Default to using the iOS account framework for handling twitter auth
    let useACAccount = true
    var tweets : [JSONValue] = []
    
    required init?(coder aDecoder: NSCoder) {
        self.swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT", consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(animated: Bool) {
        
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

            // Prompt the user for permission to their twitter account stored in the phone's settings
            accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
                granted, error in

                if granted {
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)

                    if twitterAccounts?.count == 0
                    {
                        self.alertWithTitle("Error", message: "There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                    }
                    else {
                        let twitterAccount = twitterAccounts[0] as! ACAccount
                        self.swifter = Swifter(account: twitterAccount)
                        self.getSearchResults()
                    }
                }
                else {
                    self.alertWithTitle("Error", message: error.localizedDescription)
                }
            }
        
    }
    func getSearchResults() {
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        self.swifter.getSearchTweetsWithQuery("earthquake", count: 50, success: {
            (statuses: [JSONValue]?, searchMetadata: Dictionary<String, JSONValue>?) in
            
            
            if statuses != nil {
                self.tweets = statuses!
                self.tableView.reloadData()
            }
            }, failure: failureHandler)

    }
    func alertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        NSNotificationCenter.defaultCenter().removeObserver(swifter, name: "SwifterCallbackNotificationName", object: nil)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
       
        cell.textLabel?.text = tweets[indexPath.row]["text"].string
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        // cell.textLabel?.lineBreakMode = .ByWordWrapping
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }


}