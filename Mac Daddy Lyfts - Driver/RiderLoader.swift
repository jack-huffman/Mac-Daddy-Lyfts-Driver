//
//  RiderLoader.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/19/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import Foundation
class RiderLoader {
    static let baseUrlString = "https://jl-m.org/MDL-API/public/riders"
    
    
    class func load(userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, [Rider]?, String?) -> Void) {
        
        let urlString = baseUrlString
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "the url for requesting riders is invalid")
            })
            return
        }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                var errorString = "data not available for requested riders"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
                return
            }
            
            let (riders, errorString) = parse(with: data)
            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                    
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, riders, nil)
                })
            }
        }
        
        task.resume()
    }
    
    class func parse(with data: Data) -> ([Rider]?, String?) {
        
        var riders = [Rider]()
        
        // for debugging: to see json as String printed
//        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
//            print(jsonString)
//        }
        
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
        let ridersNode = json as? [[String:Any]] else {
                return (nil, "unable to parse response from server")
        }
        
        for rider in ridersNode {
            if let id = rider["id"] as? Int, let status = rider["active"] as? Int, let latitude = rider["latitude"] as? Double, let longitude = rider["longitude"] as? Double, let name = rider["name"] as? String, let phoneNumber = rider["phoneNumber"] as? String, let destination = rider["destination"] as? String, let numPassengers = rider["seatsRequested"] as? Int, let createTime = rider["created_at"] as? String {
                
                let rider = Rider(id: id, status: status, latitude: latitude, longitude: longitude, name: name, phoneNumber: phoneNumber, destination: destination, numPassengers: numPassengers, createTime: createTime)
                
                
                riders.append(rider)
            }
        }
        return(riders, nil)
    }
}
