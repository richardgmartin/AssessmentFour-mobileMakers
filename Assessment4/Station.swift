//
//  Station.swift
//  Assessment4
//
//  Created by Richard Martin on 2016-02-05.
//  Copyright © 2016 Mobile Makers. All rights reserved.
//

import UIKit

class Station: NSObject {
    
    var latitude: Double
    var longitude: Double
    var availableBikes: Int
    var streetAddress: String

    
    init(stationDictionary: NSDictionary ) {
        
        self.latitude = stationDictionary["latitude"] as! Double
        self.longitude = stationDictionary["longitude"] as! Double
        self.streetAddress = stationDictionary["stAddress1"] as! String
        self.availableBikes = stationDictionary["availableBikes"] as! Int
        
    }
    
}
