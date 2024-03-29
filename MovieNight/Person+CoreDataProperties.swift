//
//  Person+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 11/11/22.
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
    @NSManaged public var filmography: NSSet?
    
    public var filmographyArray: [Media] {
        let set = filmography as? Set<Media> ?? []
        return set.sorted {
            $0.popularity > $1.popularity
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

// MARK: Generated accessors for filmography
extension Person {

    @objc(addFilmographyObject:)
    @NSManaged public func addToFilmography(_ value: Media)

    @objc(removeFilmographyObject:)
    @NSManaged public func removeFromFilmography(_ value: Media)

    @objc(addFilmography:)
    @NSManaged public func addToFilmography(_ values: NSSet)

    @objc(removeFilmography:)
    @NSManaged public func removeFromFilmography(_ values: NSSet)

}

extension Person : Identifiable {

}
