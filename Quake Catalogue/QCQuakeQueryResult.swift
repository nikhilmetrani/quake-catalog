//
//  QCQuakeQueryResult.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation

class QCQuakeQueryResult {
    
    var metadata: QCQuakeQueryResultMetadata?
    var features: [QCQuakeFeature] = []
    var bbox: [Double] = []
    
    init (json: NSDictionary) {
        if let type = json["type"] as? String {
            if type == "FeatureCollection" {
                if let metadata = json["metadata"] as? NSDictionary {
                    self.metadata = QCQuakeQueryResultMetadata(json: metadata)
                }
                if let features = json["features"] as? NSArray {
                    for feature in features {
                        let quakeFeature = QCQuakeFeature(json: (feature as? NSDictionary)!)
                        self.features.append(quakeFeature)
                    }
                }
                if let bbox = json["bbox"] as? NSArray {
                    for item in bbox {
                        self.bbox.append((item as? Double)!)
                    }
                }
            }
        }
    }
}