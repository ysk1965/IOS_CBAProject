//
//  MapViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 26..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 500
    
    @IBAction func Back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    var locations : [CampLocation] = []
    
    func loadInitData(){
        /*
        var location = CLLocationCoordinate2DMake(37.322550, 126.793821)
        var span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        var region = MKCoordinateRegion(center: location, span: span)
        
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "안산 수양관"
        annotation.subtitle = "Check for Alert"
        
        mapView?.setRegion(region, animated: true)
        mapView?.addAnnotation(annotation)
        */
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let location = view.annotation as! CampLocation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard let annotation = annotation as? CampLocation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        centerMapOnLocation(location: CLLocation(latitude: 37.322550, longitude: 126.793821))
        
        mapView.delegate = self
        
        let position = CampLocation(title: "안산수양관", locationName: "안산수양관", discipline: "교회", coordinate: CLLocationCoordinate2D(latitude: 37.322550, longitude: 126.793800))
        mapView.addAnnotation(position)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
