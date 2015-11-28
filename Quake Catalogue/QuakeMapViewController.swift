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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.features = QCURLQuery.instance.searchResult!.features
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        mapView.showsUserLocation = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        //Check if the map is with old search, take a latest data
        
        refreshMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshMap(){
        
        if hitCount != QCURLQuery.instance.hitCount{
            
            self.hitCount = QCURLQuery.instance.hitCount
            
            self.features = QCURLQuery.instance.searchResult!.features
            
            if self.features.count > 0 {
                
                for quake in features{
                    
                    let venueLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: quake.geometry!.latitude!, longitude: quake.geometry!.longitude!)
                    
                    let theRegion : MKCoordinateRegion = MKCoordinateRegion(center: venueLocation, span: theSpan)
                    
                    mapView.setRegion(theRegion, animated: true)
                    
                    addMapAnnotation(venueLocation, title:quake.title!, subTitle:"")
                    
                }
                
            }
            
        }

    }
    
    func addMapAnnotation(venueLocation:CLLocationCoordinate2D, title:String, subTitle:String){
        let venuePoint = MKPointAnnotation()
        venuePoint.coordinate = venueLocation
        venuePoint.title = title
        venuePoint.subtitle = subTitle
        mapView.addAnnotation(venuePoint)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
