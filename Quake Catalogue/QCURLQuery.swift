//
//  QCURLQuery.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation

class QCURLQuery {
    
    private var URL: String = ""
    var queries: [String] = []
    
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
}