//
//  QCQuakeFeature.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation

class QCQuakeFeature {
    var mag: Double?
    var place: String?
    var time: Int?
    var updated: Int?
    var timeZone: Int?
    var url: String?
    var detail: String?
    var felt: Double?
    var cdi: Double?
    var mmi: Int?
    var alert: String?
    var status: String?
    var tsunami: Int?
    var sig: Int?
    var net: String?
    var code: String?
    var ids: String?
    var sources: String?
    var types: String?
    var nst: String?
    var dmin: Double?
    var rms: Double?
    var gap: Int?
    var magType: String?
    var type: String?
    var title: String?
    var geometry: QCQuakePoint?
    var id: String?
    
    init (json: NSDictionary) {
        if let type = json["type"] as? String {
            if type == "Feature" {
                if let properties = json["properties"] as? NSDictionary {
                    
                    if let mag = properties["mag"] as? Double {
                        self.mag = mag
                    }
                    
                    if let place = properties["place"] as? String {
                        self.place = place
                    }
                    
                    if let time = properties["time"] as? Int {
                        self.time = time
                    }
                    
                    if let updated = properties["updated"] as? Int {
                        self.updated = updated
                    }
                    
                    if let timeZone = properties["tz"] as? Int {
                        self.timeZone = timeZone
                    }
                    
                    if let url = properties["url"] as? String {
                        self.url = url
                    }
                    
                    if let detail = properties["detail"] as? String {
                        self.detail = detail
                    }
                    
                    if let felt = properties["felt"] as? Double {
                        self.felt = felt
                    }
                    
                    if let cdi = properties["cdi"] as? Double {
                        self.cdi = cdi
                    }
                    
                    if let mmi = properties["mmi"] as? Int {
                        self.mmi = mmi
                    }
                    
                    if let alert = properties["alert"] as? String {
                        self.alert = alert
                    }
                    
                    if let status = properties["status"] as? String {
                        self.status = status
                    }
                    
                    if let tsunami = properties["tsunami"] as? Int {
                        self.tsunami = tsunami
                    }
                    
                    if let sig = properties["sig"] as? Int {
                        self.sig = sig
                    }
                    
                    if let net = properties["net"] as? String {
                        self.net = net
                    }
                    
                    if let code = properties["code"] as? String {
                        self.code = code
                    }
                    
                    if let ids = properties["ids"] as? String {
                        self.ids = ids
                    }
                    
                    if let sources = properties["sources"] as? String {
                        self.sources = sources
                    }
                    
                    if let types = properties["types"] as? String {
                        self.types = types
                    }
                    
                    if let nst = properties["nst"] as? String {
                        self.nst = nst
                    }
                    
                    if let dmin = properties["dmin"] as? Double {
                        self.dmin = dmin
                    }
                    
                    if let rms = properties["rms"] as? Double {
                        self.rms = rms
                    }
                    
                    if let gap = properties["gap"] as? Int {
                        self.gap = gap
                    }
                    
                    if let magType = properties["magType"] as? String {
                        self.magType = magType
                    }
                    
                    if let ftype = properties["type"] as? String {
                        self.type = ftype
                    }
                    
                    if let title = properties["title"] as? String {
                        self.title = title
                    }
                }
                
                if let geometry = json["geometry"] as? NSDictionary {
                    self.geometry = QCQuakePoint(json: geometry)
                }
                
                if let id = json["id"] as? String {
                    self.id = id
                }
            }
        }
    }
}