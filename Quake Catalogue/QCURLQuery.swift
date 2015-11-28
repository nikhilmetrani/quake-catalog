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
    
    var URL: String?
    var queries: [String] = []
    var delegate: QCURLQueryDelegate?
    var searchResult: QCQuakeQueryResult?
    
    var URLWithQueries: String {
        get {
            return "\(URL!)?\(concatnateURLQueriesAsString())"
        }
    }
    
    static let instance: QCURLQuery = QCURLQuery()
    
    private init() {
        
    }
    
    func createQueryFromSearchCriteria(searchCriteria: QuakeSearchCriteria) {
        clearQueries()
        if let minmag = searchCriteria.minmagnitude {
            addQuery(parameterName: "minmagnitude", parameterValue: "\(minmag)")
            if let maxmag = searchCriteria.maxmagnitude {
                if maxmag > minmag {
                    addQuery(parameterName: "maxmagnitude", parameterValue: "\(maxmag)")
                }
            }
        }
        
        if let year = searchCriteria.year {
            if let month = searchCriteria.month {
                if let day = searchCriteria.day {
                    let startTime = "\(year)-\(month)-\(day)T00:00:00"
                    let endTime = "\(year)-\(month)-\(day)T23:59:59"
                    addQuery(parameterName: "starttime", parameterValue: startTime)
                    addQuery(parameterName: "endtime", parameterValue: endTime)
                    
                }
            }
        }
        addQuery(parameterName: "orderby", parameterValue: "time")
        addQuery(parameterName: "format", parameterValue: "geojson")
    }
    
    func addQuery(parameterName name: String, parameterValue value: String) {
        let query = getURLQueryAsString(name, value: value)
        queries.append(query)
    }
    
    func clearQueries() {
        queries = []
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
        
        if self.URL == nil {
            return
        }
        
        let quakeSearchResultHandler: (NSData?, NSURLResponse?, NSError?) -> () = { (data: NSData?,response: NSURLResponse?,  error: NSError?) -> Void in
            do {
                let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                print("AsSynchronous\(jsonResult)")
                self.searchResult = QCQuakeQueryResult(json: jsonResult)
                if let delegateObj: QCURLQueryDelegate = self.delegate {
                    delegateObj.didReturnSearchResults(self.searchResult!)
                }
                
            } catch {
                
            }
        }
        
        let url: NSURL = NSURL(string: URLWithQueries)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: quakeSearchResultHandler)
        task.resume()
    }
}