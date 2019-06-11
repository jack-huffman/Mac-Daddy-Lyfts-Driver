//
//  Updater.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/26/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//
import UIKit
import Foundation

class Updater {
    
    static let updateRiderUrlString = "https://jl-m.org/MDL-API/public/riderUpdate/"
    static let deleteRiderUrlString = "https://jl-m.org/MDL-API/public/riderDelete/"
    
    static let updateDriverUrlString = "https://jl-m.org/MDL-API/public/driverUpdate/"
    
    // used to change the activity value of a ride on the server
    class func updateRider(id: Int, active: Int, userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, String?) -> Void) {
        

        let urlString = updateRiderUrlString + String(id) + "?active=" + String(active)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, "the url for requesting a rider is invalid")
            })
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                var errorString = "data not available for requested riders (\(id))"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, errorString)
                })
                return
            }
        }
        
        task.resume()
    }
    
    class func deleteRider(id: Int, userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?,  String?) -> Void) {
        
        let urlString = deleteRiderUrlString + String(id)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, "the url for requesting a rider is invalid")
            })
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                var errorString = "data not available for requested riders (\(id))"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, errorString)
                })
                return
            }
        }
        
        task.resume()
    }
    
    class func updateDriver(id: Int, name: String, active: Int, latitude: Double, longitude: Double, userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, String?) -> Void) {
        
        
        let urlString = updateDriverUrlString + String(id) + "?active=" + String(active) + "&name=" + String(name) + "&latitude=" +
            String(latitude) + "&longitude=" + String(longitude)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, "the url for requesting a rider is invalid")
            })
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                var errorString = "data not available for requested riders (\(id))"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, errorString)
                })
                return
            }
        }
        
        task.resume()
    }
    
}
