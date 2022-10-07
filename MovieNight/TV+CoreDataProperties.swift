//
//  TV+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 10/7/22.
//
//

import Foundation
import CoreData


extension TV {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TV> {
        return NSFetchRequest<TV>(entityName: "TV")
    }

    @NSManaged public var backdrop_path: String?
    @NSManaged public var discovery: Bool
    @NSManaged public var id: Int32
    @NSManaged public var media_type: String?
    @NSManaged public var original_language: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var title: String?
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int16
    @NSManaged public var watched: Bool
    @NSManaged public var genre_ids: NSObject?
    @NSManaged public var popularity: Double
    
    var wrappedBackdropPath: String {
        backdrop_path ?? "Unknown"
    }
    
    var wrappedPosterPath: String {
        poster_path ?? "Unknown"
    }
    
    var wrappedMediaType: String {
        media_type ?? "Unknown"
    }
    
    var wrappedOriginalTitle: String {
        original_title ?? "Unknown"
    }
    
    var wrappedOriginalLanguage: String {
        original_language ?? "Unknown"
    }
    
    var wrappedOverview: String {
        overview ?? "Unknown"
    }
    
    var wrappedReleaseDate: String {
        release_date ?? "Unknown"
    }
    
    var wrappedTitle: String {
        title ?? "Unknown"
    }

}

extension TV : Identifiable {

}
