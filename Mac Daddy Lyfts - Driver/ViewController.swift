//
//  ViewController.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 3/21/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var username: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func usernameEntered(_ sender: UITextField) {
        username = sender.text
    }
    
    @IBAction func passwordEntered(_ sender: UITextField) {
        password = sender.text
    }
    
    @IBAction func login(_ sender: UIButton) {
       
       // performSegue(withIdentifier: "listCartNumbers", sender: nil)
        
    }
}

