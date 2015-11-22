//
//  QCQuakeQueryResultMetadata.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation

class QCQuakeQueryResultMetadata {
    var generated: String?
    var url: String?
    var title: String?
    var status: Int?
    var api: String?
    var count: Int?
    
    init(json: NSDictionary) {
        if let gen = json["generated"] as? String {
            self.generated = gen
        }
        if let url = json["url"] as? String {
            self.url = url
        }
        if let title = json["title"] as? String {
            self.title = title
        }
        if let status = json["status"] as? Int {
            self.status = status
        }
        if let api = json["api"] as? String {
            self.api = api
        }
        if let count = json["count"] as? Int {
            self.count = count
        }
    }
}