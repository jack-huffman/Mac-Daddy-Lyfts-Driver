//
//  User+CoreDataProperties.swift
//  Mac Daddy Lyfts - Driver
//
//  Created by Jackson Huffman on 4/30/18.
//  Copyright © 2018 Jackson Huffman. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?

}
