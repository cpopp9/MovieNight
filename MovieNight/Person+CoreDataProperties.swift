//
//  Person+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 11/2/22.
//
//

import Foundation
import CoreData
import UIKit


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var credit_id: String?
    @NSManaged public var name: String?
    @NSManaged public var popularity: Double
    @NSManaged public var profile_path: String?
    @NSManaged public var profileImage: UIImage?
    @NSManaged public var biography: String?
    @NSManaged public var birthday: String?
    @NSManaged public var knownFor: String?
    @NSManaged public var place_of_birth: String?
    @NSManaged public var deathday: String?
    @NSManaged public var id: Int
    @NSManaged public var mediaCredit: Int
    @NSManaged public var media: NSSet?
    
    
    public var mediaArray: [Media] {
        let set = media as? Set<Media> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    var wrappedCreditID: String {
        credit_id ?? "--"
    }
    
    var wrappedBiography: String {
        biography ?? "--"
    }
    
    var wrappedBirthday: String {
        birthday ?? "--"
    }
    
    var wrappedDeathDay: String {
        deathday ?? "--"
    }
    
    var wrappedPlaceOfBirth: String {
        place_of_birth ?? "--"
    }
    
    var wrappedKnownFor: String {
        
        if knownFor == "Acting" {
            return "Actor"
        } else if knownFor == "Directing" {
            return "Director"
        } else {
            return knownFor ?? "--"
        }
    }
        
        
    var wrappedPosterImage: UIImage {
        profileImage ?? UIImage(named: "profile_placeholder")!
    }
    
    var wrappedName: String {
        name ?? "--"
    }
    
    var wrappedProfilePath: String {
        profile_path ?? "--"
    }

}

// MARK: Generated accessors for media
extension Person {

    @objc(addMediaObject:)
    @NSManaged public func addToMedia(_ value: Media)

    @objc(removeMediaObject:)
    @NSManaged public func removeFromMedia(_ value: Media)

    @objc(addMedia:)
    @NSManaged public func addToMedia(_ values: NSSet)

    @objc(removeMedia:)
    @NSManaged public func removeFromMedia(_ values: NSSet)

}

extension Person : Identifiable {

}
