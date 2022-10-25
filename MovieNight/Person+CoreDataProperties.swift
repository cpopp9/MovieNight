//
//  Person+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 10/25/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var credit_id: String
    @NSManaged public var name: String?
    @NSManaged public var popularity: Double
    @NSManaged public var profile_path: String?
    
    var wrappedName: String {
        name ?? "--"
    }
    
    var wrappedProfilePath: String {
        profile_path ?? "--"
    }

}

extension Person : Identifiable {

}
