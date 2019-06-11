//
//  Driver.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/27/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import Foundation

class Driver {
    let id: Int
    var status: Int
    let name: String
    var latitude: Double
    var longitude: Double
    
    init(_ id: Int, _ status: Int, _ name: String, _ latitude: Double, _ longitude: Double) {
        self.id = id
        self.status = status
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
