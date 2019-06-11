//
//  MapViewController.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/2/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var timer = Timer()
    
    var name: String = ""
    
    var riders = [Rider]()
    var selectedAnnotation: RiderPointAnnotation?
    var interactedAnnotations = [RiderPointAnnotation]()
    
    var driverStatus: Int = 1
    
    var locationManager = CLLocationManager()
    
    var timeLastChecked = Date()
    
    var cartPicked: Int = 0
    
    let centerLatitude = 38.948
    let centerLongitude = -92.328
    let latitudeDelta = 0.02
    let longitudeDelta = 0.02
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // get user's location
        getCurrentLocation()
        
        // update driver on server to show cart has been picked
        if let coordinate = locationManager.location?.coordinate {
            updateDriver(coordinate.latitude, coordinate.longitude, 1)
        }
        
        // Set label to reflect cart picked in previous view
        setCartLabel(cartPicked)
        
        //set old date for fresh reference when first loading riders
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        formatter.timeZone = NSTimeZone(abbreviation: "CST")! as TimeZone
        timeLastChecked = formatter.date(from: "2018-01-01 00:00:00")!
        
        
        // load riders from JSON data and refresh every 30 sec
        loadRiders()
        startTimer()
        
        // set default map region
        createMap()

        
        }
    

    func setCartLabel(_ cartPicked: Int) {
        switch cartPicked {
        case 1:
            cartLabel.text = "Cart 1"
            break
        case 2:
            cartLabel.text = "Cart 2"
            break
        case 3:
            cartLabel.text = "Cart 3"
            break
        default:
            cartLabel.text = "No Cart"
        }
    }
    
    func createMap() {
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.mapView.setRegion(region, animated: false)
        self.mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        
        let annotationIdentifier = "location"

        if (annotation.isKind(of: MKUserLocation.self)){
            return nil
        }
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = selectedAnnotation
            view = dequeuedView
        } else {

            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.canShowCallout = true
            view.animatesDrop = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? RiderPointAnnotation
            interactedAnnotations.append(selectedAnnotation!)
            
            performSegue(withIdentifier: "rideInformation", sender: self)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func activeToggle(_ sender: UISwitch) {
        var toggle: Int = 1
        var statusChange = UIAlertController()
        if sender.isOn {
            toggle = 1
            statusChange = UIAlertController(title: "Active", message: "Setting cart \(cartPicked) to active", preferredStyle: UIAlertControllerStyle.alert)
        } else {
            toggle = -1
            statusChange = UIAlertController(title: "Busy", message: "Setting cart \(cartPicked) to busy", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        if let latitude = self.locationManager.location?.coordinate.latitude, let longitude = self.locationManager.location?.coordinate.longitude {
            updateDriver(latitude, longitude, toggle)
            
            statusChange.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
            self.present(statusChange, animated: true, completion: nil)
                
            print("Setting cart \(cartPicked)'s activity to \(toggle)")
        }
    }
    
    // run loadRiders() every 15 sec
    func startTimer() {
        
        // should timer run at a shorter interval? Every 5 seconds?
        // in case two drivers accept the same ride within the 15 second update
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            
            self?.loadRiders()
            
            // check for pins that need to be deleted
            for annotation in (self?.interactedAnnotations)! {
                if annotation.rider?.status == 0 {
                    self?.mapView.removeAnnotation(annotation)
                    print("Removed \(annotation.rider!.name)'s pin from map")
                }
            }
            
            // update driver's position on server
            if let updatedLocation = self?.locationManager.location?.coordinate {
                self?.updateDriver(updatedLocation.latitude, updatedLocation.longitude, 1)
            }
        }
    }
    
    // fetch riders from server and add to map
    func loadRiders() {

        RiderLoader.load(userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
            (userInfo, riders, errorString) in

            if let errorString = errorString {
                print("Error: \(errorString)")
            } else if let riders = riders {
                self.riders = riders
                
                // no completed rides printed
                // status = 1 means pick me up
                var printedRides = riders.filter {
                    $0.status == 1
                }
                
                print("Last checked: \(self.timeLastChecked)")
                
                // compare rides with time last checked
                // time last checked initialized to really old date
                // so first check gets all riders
                printedRides = printedRides.filter {
                    $0.createTime > self.timeLastChecked
                }
                
                // set timeLastChecked to current time
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                formatter.timeZone = NSTimeZone(abbreviation: "CST")! as TimeZone
                self.timeLastChecked = Date()
                
                print("timeLastChecked: \(self.timeLastChecked)")
                                
                print("Added \(printedRides.count) pin(s) to the map")
                
                for rider in printedRides {
                    self.printRider(rider)
                }
                
            }
        }
    }
    
    
    func printRider(_ rider: Rider) {
            let point = RiderPointAnnotation()
            point.rider = rider
            point.coordinate = CLLocationCoordinate2D(latitude: rider.latitude, longitude: rider.longitude)
            point.title = rider.name
            point.subtitle = "Seats: \(rider.numPassengers)"
            mapView.addAnnotation(point)
    }
    
    func getCurrentLocation()
    {
        self.locationManager.requestAlwaysAuthorization()
        
        // Use location in background
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        print("User location: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
            
        }
    
    func updateDriver(_ latitude: Double, _ longitude: Double, _ active: Int) {
        Updater.updateDriver(id: cartPicked, name: self.name, active: active, latitude: latitude , longitude: longitude, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
            (userInfo, errorString) in
            
            if let errorString = errorString {
                print("Error: \(errorString)")
            } else {
                return
            }
        }
    }
    
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        let logoutAlert = UIAlertController(title: "Exit Cart", message: "Stop your session as cart \(cartPicked)?", preferredStyle: UIAlertControllerStyle.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "End Session", style: .default, handler: { (action: UIAlertAction!) in
            
            // logout
            self.timer.invalidate()
            self.updateDriver(0, 0, 0)
            print("Logging out of cart \(self.cartPicked)")
            self.dismiss(animated: true, completion: nil)
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            // cancel
            logoutAlert.dismiss(animated: true, completion: nil)
        }))
        present(logoutAlert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RideInfoViewController, let annotation = selectedAnnotation, let rider = annotation.rider {
            destination.rider = rider
        }
    }
}

