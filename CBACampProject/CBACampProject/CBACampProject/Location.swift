//
//  Location.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 27..
//  Copyright © 2018년 mac. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class CampLocation: NSObject, MKAnnotation{
    let title: String?
    let locationName : String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName:String, discipline: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String?{
        return locationName
    }
    
    func mapItem() -> MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
