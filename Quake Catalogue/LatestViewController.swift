//
//  LatestViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 21/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import MapKit

class LatestViewController: UIViewController, MKMapViewDelegate, QCURLQueryDelegate {

    @IBOutlet weak var mapViewLatestQuake: MKMapView!
    @IBOutlet weak var stepperMapView: UIStepper!
    var mapStepperIsVertical: Bool = false
    
    let quakeQueryURLAsString: String = "http://earthquake.usgs.gov/fdsnws/event/1/query"
    
    var urlQuery: QCURLQuery = QCURLQuery.instance
    
    var quakeCoordinateAndSpan: (quakeCoordinates: CLLocationCoordinate2D, spanArea: MKCoordinateSpan)?
    
    var quakesToday: QCQuakeQueryResult?
    
    var latestQuake: QCQuakeFeature?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlQuery.URL = quakeQueryURLAsString
        urlQuery.delegate = self
        prepareUrlQueryForToday()
        mapViewLatestQuake.delegate = self
        
        self.urlQuery.execute()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if !mapStepperIsVertical {
            stepperMapView.transform=CGAffineTransformRotate(stepperMapView.transform, CGFloat(270.0/180*M_PI));
            mapStepperIsVertical = true
        }
        if let latestQuake = self.quakesToday?.features[0] {
            self.latestQuake = latestQuake
            if let latestCoordinates = latestQuake.geometry {
                self.quakeCoordinateAndSpan = self.prepareMapViewInfoData(2, latitude: (latestCoordinates.latitude)!, longitude: (latestCoordinates.longitude)!)
                self.setMapViewInfo(self.quakeCoordinateAndSpan!.quakeCoordinates, span: self.quakeCoordinateAndSpan!.spanArea)
                self.addAnnotationToMapView(self.quakeCoordinateAndSpan!.quakeCoordinates, title: (latestQuake.title)!)
            }
        }
    }
    
    func didReturnSearchResults(quakeSearchResult: QCQuakeQueryResult) {
        self.quakesToday = quakeSearchResult
        if let latestQuake = self.quakesToday?.features[0] {
            self.latestQuake = latestQuake
            if let latestCoordinates = latestQuake.geometry {
                self.quakeCoordinateAndSpan = self.prepareMapViewInfoData(2, latitude: (latestCoordinates.latitude)!, longitude: (latestCoordinates.longitude)!)
                self.setMapViewInfo(self.quakeCoordinateAndSpan!.quakeCoordinates, span: self.quakeCoordinateAndSpan!.spanArea)
                self.addAnnotationToMapView(self.quakeCoordinateAndSpan!.quakeCoordinates, title: (latestQuake.title)!)
            }
        }
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
    
    func prepareUrlQueryForToday() {
        let dateTimeComponents: QCDateTimeConponents = QCDateTimeConponents()
        urlQuery.addQuery(parameterName: "starttime", parameterValue: dateTimeComponents.todayStart)
        urlQuery.addQuery(parameterName: "endtime", parameterValue: dateTimeComponents.todayEnd)
        urlQuery.addQuery(parameterName: "orderby", parameterValue: "time")
        urlQuery.addQuery(parameterName: "format", parameterValue: "geojson")
        urlQuery.addQuery(parameterName: "minmagnitude", parameterValue: "4")
    }
    
    @IBAction func shareTapped(sender: UIButton) {
        
    }
}
