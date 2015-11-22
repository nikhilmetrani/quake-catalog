//
//  QCDateTimeComponents.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation

class QCDateTimeConponents {
    
    private var dateTimeConponents: NSDateComponents?
    
    var year: Int {
        get {
            return dateTimeConponents!.year
        }
    }
    
    var month: Int {
        get {
            return dateTimeConponents!.month
        }
    }
    
    var day: Int {
        get {
            return dateTimeConponents!.day
        }
    }
    
    var todayStart: String {
        get {
            return "\(year)-\(month)-\(day)T00:00:00"
        }
    }
    
    var todayEnd: String {
        get {
            return "\(year)-\(month)-\(day)T23:59:59"
        }
    }
    
    init () {
        dateTimeConponents = getDateTimeComponents()
    }
    
    private func getDateTimeComponents() -> NSDateComponents {
        // get the current date and time
        let currentDateTime = NSDate()
        
        // get the user's calendar
        let userCalendar = NSCalendar.currentCalendar()
        
        // choose which date and time components are needed
        let requestedComponents: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.Second
        ]
        
        // get the components
        let dateTimeComponents = userCalendar.components(requestedComponents, fromDate: currentDateTime)
        
        return dateTimeComponents
    }
}