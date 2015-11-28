//
//  QuakeDetailViewController.swift
//  Quake Catalogue
//
//  Author : Jagadeesh Potturi on 28/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class QuakeDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var quakeTitle: UILabel!
    
    var selectedQuakeFeature: QCQuakeFeature?
    
    @IBOutlet weak var viewToggler: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var webView: UIWebView!
    
    var locationManager:CLLocationManager!
    
    let theSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
         progress.stopAnimating()
        
        webView.delegate = self
        
        mapView.hidden = false
        webView.hidden = true
        //let buttonBack = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "updateSearchCriteria:")
        //self.navigationItem.leftBarButtonItem = buttonBack
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        mapView.showsUserLocation = true
        
        if(selectedQuakeFeature == nil){
            return;
        }
        
        
        let venueLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: selectedQuakeFeature!.geometry!.latitude!, longitude: selectedQuakeFeature!.geometry!.longitude!)
        
        let theRegion : MKCoordinateRegion = MKCoordinateRegion(center: venueLocation, span: theSpan)
        
        mapView.setRegion(theRegion, animated: true)
        
        addMapAnnotation(venueLocation, title:selectedQuakeFeature!.title!, subTitle:"")
        
        quakeTitle.text = selectedQuakeFeature!.title!
        
    }
    
    func addMapAnnotation(venueLocation:CLLocationCoordinate2D, title:String, subTitle:String){
        let venuePoint = MKPointAnnotation()
        venuePoint.coordinate = venueLocation
        venuePoint.title = title
        venuePoint.subtitle = subTitle
        mapView.addAnnotation(venuePoint)
        
    }

    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    @IBAction func onViewToggle(sender: AnyObject) {
        
        switch viewToggler.selectedSegmentIndex
        {
        case 0:
            mapView.hidden = false
            webView.hidden = true
        case 1:
            mapView.hidden = true
            webView.hidden = false
            let url = NSURL (string: selectedQuakeFeature!.url!);
            let requestObj = NSURLRequest(URL: url!);
            webView.loadRequest(requestObj);
            
        default:
            break;
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        progress.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        progress.stopAnimating()
    }
    
    
}
