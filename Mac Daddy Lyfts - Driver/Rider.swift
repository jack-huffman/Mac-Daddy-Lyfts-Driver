//
//  Rider.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/16/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import Foundation
import MapKit

class Rider {

    let id: Int
    var status: Int
    let latitude: Double
    let longitude: Double
    let name: String
    let phoneNumber: String
    let destination: String
    let numPassengers: Int
    var createTime: Date
    let coordinate: CLLocationCoordinate2D

    init(id: Int, status: Int, latitude: Double, longitude: Double, name: String, phoneNumber: String, destination: String, numPassengers: Int, createTime: String) {
        self.id = id
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.phoneNumber = phoneNumber
        self.destination = destination
        self.numPassengers = numPassengers
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createTime = formatter.date(from: createTime)!

    }


}
