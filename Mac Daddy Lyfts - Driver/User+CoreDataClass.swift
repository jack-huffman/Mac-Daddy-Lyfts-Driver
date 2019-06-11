//
//  User+CoreDataClass.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/30/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//
//

import UIKit
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    convenience init?(name: String?, password: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: User.entity(), insertInto: managedContext)
        self.name = name
        self.password = password
        
    }
}
