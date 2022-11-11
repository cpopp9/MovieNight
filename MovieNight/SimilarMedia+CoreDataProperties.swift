//
//  SimilarMedia+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 11/1/22.
//
//

import Foundation
import CoreData


extension SimilarMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SimilarMedia> {
        return NSFetchRequest<SimilarMedia>(entityName: "SimilarMedia")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var media: NSSet?
    
    public var wrappedTitle: String {
        title ?? "Unknown"
    }
    
    public var mediaArray: [Media] {
        let set = media as? Set<Media> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }

}

// MARK: Generated accessors for media
extension SimilarMedia {

    @objc(addMediaObject:)
    @NSManaged public func addToMedia(_ value: Media)

    @objc(removeMediaObject:)
    @NSManaged public func removeFromMedia(_ value: Media)

    @objc(addMedia:)
    @NSManaged public func addToMedia(_ values: NSSet)

    @objc(removeMedia:)
    @NSManaged public func removeFromMedia(_ values: NSSet)

}

extension SimilarMedia : Identifiable {

}
