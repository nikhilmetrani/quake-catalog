//
//  QuakeMapViewController.swift
//  Quake Catalogue
//
//  Created by jagadeesh on 28/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class QuakeMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var features: [QCQuakeFeature] = []
    
    var hitCount:Int = 0;
    
    var locationManager:CLLocationManager!
    
    let theSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    
    var currentUserLocation:CLLocation?
    var locations:[MKPointAnnotation]!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.features = QCURLQuery.instance.searchResult!.features
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.startMonitoringSignificantLocationChanges()
        
        
        mapView.showsUserLocation = true
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //Check if the map is with old search, take a latest data
        print("viewDidAppear")
        locationManager.startUpdatingLocation()
       // refreshMap()
       // locationManager.startMonitoringSignificantLocationChanges()

    }
    
    override func viewDidDisappear(animated: Bool) {
    
        super.viewDidDisappear(animated)
       // locationManager.stopMonitoringSignificantLocationChanges()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshMap(){
        
        if hitCount != QCURLQuery.instance.hitCount{
            
            mapView.removeAnnotations(mapView.annotations)
            locations = [MKPointAnnotation]()
            
            self.hitCount = QCURLQuery.instance.hitCount
            
            self.features = QCURLQuery.instance.searchResult!.features
            
            print("hasQuakes:\(self.features.count)")
            if self.features.count > 0 {
                
                for quake in features{
                    
                    let venueLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: quake.geometry!.latitude!, longitude: quake.geometry!.longitude!)
                    
                    let theRegion : MKCoordinateRegion = MKCoordinateRegion(center: venueLocation, span: theSpan)
                    
                    mapView.setRegion(theRegion, animated: true)
                    
                    
                    var distanceStr:String!
                    if(currentUserLocation != nil)
                    {
                        let loc = CLLocation(latitude: venueLocation.latitude, longitude: venueLocation.longitude)
                        
                        let distance = currentUserLocation!.distanceFromLocation(loc)
                        
                        let distanceValue = Float(distance.description)!/1000
                        distanceStr = "\(distanceValue) KM away from Current Location"
                        
                    }else
                    {
                        
                        distanceStr = ""
                    }
                    
                    addMapAnnotation(venueLocation, title:quake.title!, subTitle:distanceStr, feature: quake)
                }
                mapView.addAnnotations(locations)
            }
            
        }

    }
    
    func addMapAnnotation(venueLocation:CLLocationCoordinate2D, title:String, subTitle:String, feature:QCQuakeFeature){
        let venuePoint = QCMapAnnotation(title: title, subtitle: subTitle, loc: venueLocation, feature: feature)
        //print(subTitle)
        locations.append(venuePoint)
    }
    
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            if annotation is QCMapAnnotation {
                let myAnno:QCMapAnnotation = annotation as! QCMapAnnotation
                
                let reuseId = "pin"
                var pinView:SVPulsingAnnotationView? =   mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? SVPulsingAnnotationView
                if pinView == nil {
                    pinView = SVPulsingAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    pinView!.annotationColor = self.getPinColor(myAnno.feature)
                    pinView!.canShowCallout = true
                    //pinView!.rightCalloutAccessoryView = UIButton.add
                }
                else {
                    pinView!.annotation = annotation
                }
                return pinView;
            }
            else{
                return nil
            }
    }
    
    func getPinColor(feature: QCQuakeFeature) -> UIColor
    {
        if(feature.mag >= 6){
            return UIColor.redColor()
        }else if(feature.mag >= 5){
            return UIColor.orangeColor()
        }else if(feature.mag >= 4){
            return UIColor.purpleColor()
        }
        else{
            return UIColor.grayColor()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentUserLocation = locations.last
        refreshMap()
        
        //print("lat: \(locations.last?.coordinate.latitude)");
        if(currentUserLocation != nil)
        {
            locationManager.stopUpdatingLocation()
            //locationManager.startMonitoringSignificantLocationChanges()
        }
    }
   // func location
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
