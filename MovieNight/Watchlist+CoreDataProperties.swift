    //
    //  Watchlist+CoreDataProperties.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/3/22.
    //
    //

import Foundation
import CoreData


extension Watchlist {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watchlist> {
        return NSFetchRequest<Watchlist>(entityName: "Watchlist")
    }
    
    @NSManaged public var backdrop_path: String?
    @NSManaged public var id: Int32
    @NSManaged public var media_type: String?
    @NSManaged public var original_language: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: Date?
    @NSManaged public var title: String?
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int16
    @NSManaged public var watched: Bool
    @NSManaged public var discovery: Bool
    
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
    
//    var wrappedReleaseDat: Date {
//        release_date ?? Date("2022-04-15")
//    }
    
    var wrappedTitle: String {
        title ?? "Unknown"
    }
    
}

extension Watchlist : Identifiable {
    
}
