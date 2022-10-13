//
//  Movie+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 10/12/22.
//
//

import Foundation
import CoreData
import UIKit


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var backdrop_path: String?
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
    @NSManaged public var popularity: Double
    @NSManaged public var watchlist: Bool
    @NSManaged public var isSearchMedia: Bool
    @NSManaged public var isDiscoverMedia: Bool
    @NSManaged public var posterImage: UIImage?
    @NSManaged public var backdropImage: UIImage?
    
    var wrappedBackdropPath: String {
        backdrop_path ?? "a2n6bKD7qhCPCAEALgsAhWOAQcc.jpg"
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
    
    var wrappedPosterPath: String {
    poster_path ?? "wmUeEacsFZzDndaeOtNNmy26rYJ.jpg"
    }

}

extension Movie : Identifiable {

}
