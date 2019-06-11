//
//  LoginViewController.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/9/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var users = [User]()

    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try managedContext.fetch(fetchRequest)
            for user in users {
                print(user.name!)
            }
            if users.count > 0 {
                name.text = users[0].name
                password.text = users[0].password
            }
        } catch {
            print("Users could not be fetched")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "Logo")
        
    }
    
    @IBAction func resignKeyboard(_ sender: UITapGestureRecognizer) {
        name.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if(password.text == "macdaddy18") {
            if name.text != "" {
                
                let user = User(name: name.text, password: password.text)
                
                do {
                    for user in users {
                        if user.name == name.text {
                            print("Duplicate user found in core data. Did not save another instance.")
                            performSegue(withIdentifier: "showCartNumbers", sender: self)
                            return
                        }
                    }
                    print("Saving user to core data")
                    let managedContext = user?.managedObjectContext
                    try managedContext?.save()
                } catch {
                    print("Context could not be saved")
                }
                
                performSegue(withIdentifier: "showCartNumbers", sender: self)
            }
            else {
                errorLabel.text = "Please enter a name"
            }
        }
        else {
            self.errorLabel.text = "Invalid password"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CartNumberViewController, let name = name.text {
            destination.name = name
        }
    }

}
