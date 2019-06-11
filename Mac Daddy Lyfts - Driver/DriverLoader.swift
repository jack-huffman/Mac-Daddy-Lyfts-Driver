//
//  DriverLoader.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/27/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import Foundation
class DriverLoader {
    static let baseUrlString = "https://jl-m.org/MDL-API/public/drivers"
    
    
    class func load(userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, [Driver]?, String?) -> Void) {
        
        let urlString = baseUrlString
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "the url for requesting drivers is invalid")
            })
            return
        }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                var errorString = "data not available for requested drivers"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
                return
            }
            
            let (drivers, errorString) = parse(with: data)
            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                    
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, drivers, nil)
                })
            }
        }
        
        task.resume()
    }
    
    class func parse(with data: Data) -> ([Driver]?, String?) {
        
        var drivers = [Driver]()
        
        // for debugging: to see json as String printed
        //        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
        //            print(jsonString)
        //        }
        
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let driversNode = json as? [[String:Any]] else {
                return (nil, "unable to parse response from server")
        }
        
        for driver in driversNode {
            if let id = driver["id"] as? Int, let status = driver["active"] as? Int, let name = driver["name"] as? String, let latitude = driver["latitude"] as? Double, let longitude = driver["longitude"] as? Double {
                
                let driver = Driver(id, status, name, latitude, longitude)
                
                
                drivers.append(driver)
            }
        }
        return(drivers, nil)
    }
}
