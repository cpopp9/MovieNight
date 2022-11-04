//
//  Filmography+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 11/4/22.
//
//

import Foundation
import CoreData


extension Filmography {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Filmography> {
        return NSFetchRequest<Filmography>(entityName: "Filmography")
    }

    @NSManaged public var personID: Int64
    @NSManaged public var name: String?
    @NSManaged public var media: NSSet?
    
    public var similarMedia: [Media] {
        let set = media as? Set<Media> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }

}

// MARK: Generated accessors for media
extension Filmography {

    @objc(addMediaObject:)
    @NSManaged public func addToMedia(_ value: Media)

    @objc(removeMediaObject:)
    @NSManaged public func removeFromMedia(_ value: Media)

    @objc(addMedia:)
    @NSManaged public func addToMedia(_ values: NSSet)

    @objc(removeMedia:)
    @NSManaged public func removeFromMedia(_ values: NSSet)

}

extension Filmography : Identifiable {

}
