//
//  ViewController.swift
//  Assessment4
//
//  Created by Ben Bueltmann on 2/3/16.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

var stationObjects = [Station]()

class StationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var stationsArray = [NSDictionary]()
    var locationManager = CLLocationManager()
    var searchActive : Bool = false
    var filtered:[String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Import divvy bike JSON file and populate stationsArray
        
        let url = NSURL(string: "http://www.divvybikes.com/stations/json/")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            do{
                let divvyStationsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                
                self.stationsArray = divvyStationsDict.objectForKey("stationBeanList") as! [NSDictionary]
                
                for dict: NSDictionary in self.stationsArray {
                    let stationObject: Station = Station(stationDictionary: dict)
                    stationObjects.append(stationObject)
                }
            }
            catch let error as NSError{
                print("JSON Error: \(error.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            
        }
        task.resume()
    
        // STEP 1. request user authorization :: NSLocationWhenInUseUsageDescription in info.plist
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // STEP 2. startUpdatingLocation of user
        
        locationManager.startUpdatingLocation()
        
    }
    
    // STEP 3. when location is acquired, the locationManager:didUpdateLocations is fired and delivers an array of multiple locations provided
    // array of locations is locations:{CLLocation]
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        
        if location?.verticalAccuracy < 1000 && location?.horizontalAccuracy < 1000 {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        filtered = self.stationsArray.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableView.reloadData()
//    }
    
    
    // MARK: table view display logic
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let station = stationObjects[indexPath.row]
        cell!.textLabel?.text = station.streetAddress
        cell!.detailTextLabel!.text = String(station.availableBikes)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.stationsArray.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dvc = segue.destinationViewController as! MapViewController
        
        dvc.station = stationObjects[tableView.indexPathForSelectedRow!.row]
    }
    
}

