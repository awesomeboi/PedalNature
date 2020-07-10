//
//  LocationNode.swift
//  PedalNature
//
//  Created by Volkan Sahin on 4.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class LocationNode : NSObject, MKAnnotation{
    let latitude : Double
    let longitude : Double
    var locationvalue : CLLocation
    public var title: String?
    var pinImage : UIImage?
    var image : UIImage
    public let coordinate: CLLocationCoordinate2D
    let starttime : CFAbsoluteTime
    let altitude : Double
    
    init(latitude : Double, longitude : Double, image : UIImage, coordinate : CLLocationCoordinate2D, starttime : CFAbsoluteTime, altitude : Double, pinImage : UIImage , locationval : CLLocation) {
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
        self.coordinate = coordinate
        self.starttime = starttime
        self.altitude = altitude
        self.pinImage = pinImage
        self.locationvalue = locationval
    }
}
