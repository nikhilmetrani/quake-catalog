//
//  LatestViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 21/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import MapKit

class LatestViewController: UIViewController, MKMapViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {

    @IBOutlet weak var mapViewLatestQuake: MKMapView!
    @IBOutlet weak var stepperMapView: UIStepper!
    var mapRegionDelta: Double = 2
    var mapStepperValue: Double = 2
    var mapStepperIsVertical: Bool = false
    
    let quakeQueryURLAsString: String = "http://earthquake.usgs.gov/fdsnws/event/1/query"
    
    var urlQuery: QCURLQuery?
    
    var quakeCoordinateAndSpan: (quakeCoordinates: CLLocationCoordinate2D, spanArea: MKCoordinateSpan)?
    
    var quakesToday: QCQuakeQueryResult?
    
    var latestQuake: QCQuakeFeature?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUrlQueryForToday()
        mapViewLatestQuake.delegate = self
        
        fireQueryForTodaysQuakes()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if !mapStepperIsVertical {
            stepperMapView.transform=CGAffineTransformRotate(stepperMapView.transform, CGFloat(270.0/180*M_PI));
            mapStepperIsVertical = true
        }
        if let latestQuake = self.quakesToday?.features[0] {
            self.latestQuake = latestQuake
            if let latestCoordinates = latestQuake.geometry {
                self.quakeCoordinateAndSpan = self.prepareMapViewInfoData(self.mapRegionDelta, latitude: (latestCoordinates.latitude)!, longitude: (latestCoordinates.longitude)!)
                self.setMapViewInfo(self.quakeCoordinateAndSpan!.quakeCoordinates, span: self.quakeCoordinateAndSpan!.spanArea)
                self.addAnnotationToMapView(self.quakeCoordinateAndSpan!.quakeCoordinates, title: (latestQuake.title)!)
            }
        }
    }
    
    func fireQueryForTodaysQuakes() {
        
        let quakeSearchResultHandler: (NSData?, NSURLResponse?, NSError?) -> () = { (data: NSData?,response: NSURLResponse?,  error: NSError?) -> Void in
            do {
                let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                print("AsSynchronous\(jsonResult)")
                self.quakesToday = QCQuakeQueryResult(json: jsonResult)
                if let latestQuake = self.quakesToday?.features[0] {
                    self.latestQuake = latestQuake
                    if let latestCoordinates = latestQuake.geometry {
                        self.quakeCoordinateAndSpan = self.prepareMapViewInfoData(self.mapRegionDelta, latitude: (latestCoordinates.latitude)!, longitude: (latestCoordinates.longitude)!)
                        self.setMapViewInfo(self.quakeCoordinateAndSpan!.quakeCoordinates, span: self.quakeCoordinateAndSpan!.spanArea)
                        self.addAnnotationToMapView(self.quakeCoordinateAndSpan!.quakeCoordinates, title: (latestQuake.title)!)
                    }
                }
            } catch {
                
            }
        }
        
        let url: NSURL = NSURL(string: (urlQuery?.URLWithQueries)!)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: quakeSearchResultHandler)
        task.resume()
    }
    
    func prepareMapViewInfoData(deltaInDegrees: Double, latitude: Double, longitude: Double)->(CLLocationCoordinate2D, MKCoordinateSpan) {
        let spanArea: MKCoordinateSpan = MKCoordinateSpanMake(deltaInDegrees, deltaInDegrees)
        let quakeCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return (quakeCoordinates, spanArea)
    }
    
    func setMapViewInfo(coordinate2D: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        let quakeRegion: MKCoordinateRegion = MKCoordinateRegionMake(coordinate2D, span)
        mapViewLatestQuake.setRegion(quakeRegion, animated: true)
    }
    
    func addAnnotationToMapView(coordinate: CLLocationCoordinate2D, title: String) {
        let quakePin: MKPointAnnotation = MKPointAnnotation()
        quakePin.coordinate = coordinate
        quakePin.title = title
        mapViewLatestQuake.addAnnotation(quakePin)
    }
    
    @IBAction func mapZoomLevelChanged(sender: UIStepper) {
        mapRegionDelta = getMapRegionDeltaFromSlider(sender.value)
        if latestQuake != nil {
            if let latestCoordinates = latestQuake!.geometry {
                self.quakeCoordinateAndSpan = self.prepareMapViewInfoData(self.mapRegionDelta, latitude: (latestCoordinates.latitude)!, longitude: (latestCoordinates.longitude)!)
                self.setMapViewInfo(self.quakeCoordinateAndSpan!.quakeCoordinates, span: self.quakeCoordinateAndSpan!.spanArea)
            }
        }
        mapStepperValue = sender.value
    }
    
    func getMapRegionDeltaFromSlider(value: Double) -> Double {
        let step = value - mapStepperValue
        print("Step: \(step)")
        return mapRegionDelta - step
    }
    
    func prepareUrlQueryForToday() {
        urlQuery = QCURLQuery(sourceURL: quakeQueryURLAsString)
        let dateTimeComponents: QCDateTimeConponents = QCDateTimeConponents()
        urlQuery?.addQuery(parameterName: "starttime", parameterValue: dateTimeComponents.todayStart)
        urlQuery?.addQuery(parameterName: "endtime", parameterValue: dateTimeComponents.todayEnd)
        urlQuery?.addQuery(parameterName: "orderby", parameterValue: "time")
        urlQuery?.addQuery(parameterName: "format", parameterValue: "geojson")
        urlQuery?.addQuery(parameterName: "minmagnitude", parameterValue: "4")
    }
    
    @IBAction func shareTapped(sender: UIButton) {
        
    }
}
