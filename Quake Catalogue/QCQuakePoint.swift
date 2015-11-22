//
//  QCQuakePoint.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation

class QCQuakePoint {
    var latitude: Double?
    var longitude: Double?
    var depth: Double?
    
    init (json: NSDictionary) {
        if let type = json["type"] as? String {
            if type == "Point" {
                if let coordinates = json["coordinates"] as? NSArray {
                    latitude = coordinates[1] as? Double
                    longitude = coordinates[0] as? Double
                    depth = coordinates[2] as? Double
                }
            }
        }
    }
}