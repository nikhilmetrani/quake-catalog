//
//  QCURLQuery.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation

protocol QCURLQueryDelegate {
    func didReturnSearchResults(quakeSearchResult: QCQuakeQueryResult)
}

class QCURLQuery {
    
    private var URL: String = ""
    var queries: [String] = []
    var delegate: QCURLQueryDelegate?
    
    var URLWithQueries: String {
        get {
            return "\(URL)?\(concatnateURLQueriesAsString())"
        }
    }
    
    init(sourceURL urlAsString: String) {
        URL = urlAsString
    }
    
    func addQuery(parameterName name: String, parameterValue value: String) {
        let query = getURLQueryAsString(name, value: value)
        queries.append(query)
    }
    
    private func getURLQueryAsString(parameter: String, value: String) -> String {
        return "\(parameter)=\(value)"
    }
    
    private func concatnateURLQueriesAsString() -> String {
        var returnQuery: String = ""
        for query in queries {
            returnQuery = returnQuery == "" ? "\(query)" : "\(returnQuery)&\(query)"
        }
        return returnQuery
    }
    
    func execute() {
        
        let quakeSearchResultHandler: (NSData?, NSURLResponse?, NSError?) -> () = { (data: NSData?,response: NSURLResponse?,  error: NSError?) -> Void in
            do {
                let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                print("AsSynchronous\(jsonResult)")
                let quakesToday = QCQuakeQueryResult(json: jsonResult)
                if let delegateObj: QCURLQueryDelegate = self.delegate {
                    delegateObj.didReturnSearchResults(quakesToday)
                }
                
            } catch {
                
            }
        }
        
        let url: NSURL = NSURL(string: (URLWithQueries))!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: quakeSearchResultHandler)
        task.resume()
    }
}