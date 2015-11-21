//
//  LatestViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 21/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import MapKit

class LatestViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapViewLatestQuake: MKMapView!
    @IBOutlet weak var stepperMapView: UIStepper!
    var mapRegionDelta: Double = 2
    var mapStepperValue: Double = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewLatestQuake.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        //let latitudeDelta: CLLocationDegrees = 1
        //let longitudeDelta: CLLocationDegrees = 1 //0.005
        //let spanArea: MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        //let quakeCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 5.8591, longitude: 126.1841)
        let (quakeCoordinates, spanArea) = prepareMapViewInfoData(1, latitude: 5.8591, longitude: 126.1841)
        setMapViewInfo(quakeCoordinates, span: spanArea)
        addAnnotationToMapView(quakeCoordinates, title: "M 4.5 - 55km S of Pondaguitan, Philippines")
        stepperMapView.transform=CGAffineTransformRotate(stepperMapView.transform, CGFloat(270.0/180*M_PI));
    }
    
    func prepareMapViewInfoData(deltaInDegrees: Double, latitude: Double, longitude: Double)->(CLLocationCoordinate2D, MKCoordinateSpan) {
        //let latitudeDelta: CLLocationDegrees = deltaInDegrees
        //let longitudeDelta: CLLocationDegrees = deltaInDegrees //0.005
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
        print("new delta: \(mapRegionDelta)")
        let (quakeCoordinates, spanArea) = prepareMapViewInfoData(mapRegionDelta, latitude: 5.8591, longitude: 126.1841)
        setMapViewInfo(quakeCoordinates, span: spanArea)
        mapStepperValue = sender.value
    }
    
    func getMapRegionDeltaFromSlider(value: Double) -> Double {
        let step = value - mapStepperValue
        print("Step: \(step)")
        return mapRegionDelta - step
    }
    
    @IBAction func shareTapped(sender: UIButton) {
        
    }
}
