//
//  CartNumberViewController.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/2/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import UIKit

class CartNumberViewController: UIViewController {
    
    var name: String = ""
    
    var cartPicked: Int = 0
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var drivers = [Driver]()
    
    // IBOutlets for buttons
    @IBOutlet weak var cart1Button: UIButton!
    @IBOutlet weak var cart2Button: UIButton!
    @IBOutlet weak var cart3Button: UIButton!
    
    @IBOutlet weak var refreshBtn: UIButton!
    
    // Activity Indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadDrivers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // check if cart is active before segue. Grey out buttons?
    // set cart to active
    @IBAction func cart1(_ sender: UIButton) {
        cartPicked = 1
        performSegue(withIdentifier: "showMap", sender: self)

    }
    
    @IBAction func cart2(_ sender: UIButton) {
        cartPicked = 2
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    @IBAction func cart3(_ sender: UIButton) {
        cartPicked = 3
        performSegue(withIdentifier: "showMap", sender: self)
    }
    

    func loadDrivers() {
        activityIndicator.startAnimating()
        DriverLoader.load(userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
            (userInfo, drivers, errorString) in
            
            if let errorString = errorString {
                print("Error: \(errorString)")
                self.activityIndicator.stopAnimating()
            }
            if let drivers = drivers {
                self.drivers = drivers
                
                // check for active status of drivers to make buttons unpressable
                for driver in drivers {
                    
                    if driver.status != 0 {
                        switch driver.id {
                        case 1:
                            self.cart1Button.isEnabled = false
                            self.cart1Button.backgroundColor = UIColor.gray
                            break
                        case 2:
                            self.cart2Button.isEnabled = false
                            self.cart2Button.backgroundColor = UIColor.gray
                            break
                        case 3:
                            self.cart3Button.isEnabled = false
                            self.cart3Button.backgroundColor = UIColor.gray
                            break
                        default:
                            print("ID not in scope of 1 through 3")
                        }
                    }
                    if driver.status == 0 {
                        switch driver.id {
                        case 1:
                            self.cart1Button.isEnabled = true
                            self.cart1Button.backgroundColor = UIColor(red: 69/255, green: 203/255, blue: 86/255, alpha: 1)
                            break
                        case 2:
                            self.cart2Button.isEnabled = true
                            self.cart2Button.backgroundColor = UIColor(red: 69/255, green: 203/255, blue: 86/255, alpha: 1)
                            break
                        case 3:
                            self.cart3Button.isEnabled = true
                            self.cart3Button.backgroundColor = UIColor(red: 69/255, green: 203/255, blue: 86/255, alpha: 1)
                            break
                        default:
                            print("ID not in scope of 1 through 3")
                        }
                    } // if
                } // for
                
                self.activityIndicator.stopAnimating()

            } // if let
        } // DriverLoader.load
    } // End func
    
    @IBAction func refreshBtnPressed(_ sender: UIButton) {
        loadDrivers()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapViewController {
            destination.cartPicked = cartPicked
            destination.name = name
        }
    }

}
