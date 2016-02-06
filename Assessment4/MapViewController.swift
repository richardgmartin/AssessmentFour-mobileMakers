//
//  MapViewController.swift
//  Assessment4
//
//  Created by Ben Bueltmann on 2/3/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var station: Station!
    var divvyDestination = MKMapItem()
    let divvyStationAnnotation = MKPointAnnotation()
    var directionsString = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(station.streetAddress)
        print(station.availableBikes)
        print(station.latitude)
        print(station.longitude)
        
        mapView.showsUserLocation = true

        
        // 1. set chicago as the region
        
        let chicagoLatitude:CLLocationDegrees = 41.8937362
        let chicagoLongitude:CLLocationDegrees = -87.6375008
        let chicagoLatDelta:CLLocationDegrees = 0.5
        let chicagoLongDelta:CLLocationDegrees = 0.5
        let span:MKCoordinateSpan = MKCoordinateSpanMake(chicagoLatDelta, chicagoLongDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(chicagoLatitude, chicagoLongitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        
        // 2. set divvy station pin info

        divvyStationAnnotation.coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude)
        divvyStationAnnotation.title = "Divvy Bikes"
        mapView.addAnnotation(divvyStationAnnotation)
        
        
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isEqual(mapView.userLocation) {
            return nil
        } else if annotation.isEqual(divvyStationAnnotation) {
            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "bikeImage")
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return pin
        } else {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return pin
        }
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        presentDirections()
        
        mapView.setRegion(MKCoordinateRegionMake(view.annotation!.coordinate, MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        
        
    }
    
    func presentDirections() {
        
        getDirectionsTo()
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Click on Information Button Again to get Directions", message: self.directionsString as String, preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
        }
        
        let directionsAction: UIAlertAction = UIAlertAction(title: "Click on Information Button Again to get Directions", style: .Default) { action -> Void in
        }
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(directionsAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }


    // logic to get directions to divvy bike station
    
    func getDirectionsTo() {
        
        
        let destMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(station.latitude, station.longitude), addressDictionary: nil)
        divvyDestination = MKMapItem(placemark: destMark)
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = divvyDestination
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) -> Void in
            let routes = response?.routes
            let route = routes?.first
            
            var x = 1
            for step in route!.steps {
                self.directionsString.appendString("\(x): \(step.instructions)\n")
                x++
            }
            print(self.directionsString)
            
        }
    }
}
