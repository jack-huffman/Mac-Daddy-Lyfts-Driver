//
//  RideInfoViewController.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/20/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import UIKit
import MapKit

class RideInfoViewController: UIViewController {

    // dynamic labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    // btns
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    
    // static labels
    @IBOutlet weak var staticRideInfo: UILabel!
    @IBOutlet weak var staticNameLabel: UILabel!
    @IBOutlet weak var staticPhoneLabel: UILabel!
    @IBOutlet weak var staticSeatsLabel: UILabel!
    @IBOutlet weak var staticDestinationLabel: UILabel!
    
    
    // variables
    var isAccepted: Bool = false
    
    var rider = Rider(id: 0, status: 0, latitude: 0, longitude: 0, name: "", phoneNumber: "", destination: "", numPassengers: 0, createTime: "1969-01-01 00:00:00")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = rider.name
        phoneLabel.text = "\(rider.phoneNumber)"
        seatsLabel.text = "\(rider.numPassengers)"
        destinationLabel.text = rider.destination
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func leftBtnPressed(_ sender: UIButton) {
        
        // Call User
        if(isAccepted) {
            callNumber(phoneNumber: "\(rider.phoneNumber)")

        }
            
        // Cancel btn
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    

    @IBAction func rightBtnPressed(_ sender: UIButton) {
        
        // Accept Ride functionality
        if(!isAccepted) {
            
        rightBtn.setTitle("Finish Ride", for: UIControlState.normal)
        rightBtn.backgroundColor = UIColor(red: 69/255, green: 203/255, blue: 86/255, alpha: 1.0)
        leftBtn.setTitle("Call User", for: UIControlState.normal)
        leftBtn.backgroundColor = UIColor.cyan


        // Set ride activity to zero: zero means picked up
        updateRider(rider.id, 0)
        rider.status = 0
            
        let mapPlacemark: MKPlacemark = MKPlacemark(coordinate: rider.coordinate)
        let mapItem: MKMapItem = MKMapItem(placemark: mapPlacemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
            
        }
        
        // Finish ride functionality
        if(isAccepted) {

            // Delete ride
            deleteRider(rider.id)
            
            // dismiss view
            self.dismiss(animated: true, completion: nil)
        }
        
        isAccepted = true
    }
    
    
    
    private func callNumber(phoneNumber: String) {
        
        if let phoneCallURL:URL = URL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL)
            }
        }
    }
    
    func updateRider(_ riderID: Int, _ active: Int) {
        
        Updater.updateRider(id: riderID, active: active, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
            (userInfo, errorString) in
            
            if let errorString = errorString {
                print("Error: \(errorString)")
            } else {
                return
            }
        }
    }
    
    func deleteRider(_ riderID: Int) {
        Updater.deleteRider(id: rider.id, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
            (userInfo, errorString) in
            
            if let errorString = errorString {
                print("Error: \(errorString)")
            } else {
                return
            }
        }
    }
    

}
