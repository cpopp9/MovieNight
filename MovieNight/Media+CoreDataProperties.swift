//
//  Media+CoreDataProperties.swift
//  MovieNight
//
//  Created by Cory Popp on 11/4/22.
//
//

import Foundation
import CoreData
import UIKit


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
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
    @NSManaged public var relatedMediaID: Int
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int16
    @NSManaged public var watched: Bool
    @NSManaged public var popularity: Double
    @NSManaged public var watchlist: Bool
    @NSManaged public var isSearchMedia: Bool
    @NSManaged public var isDiscoverMedia: Bool
    @NSManaged public var posterImage: UIImage?
    @NSManaged public var status: String?
    @NSManaged public var tagline: String?
    @NSManaged public var revenue: Int64
    @NSManaged public var runtime: Int16
    @NSManaged public var imdb_id: String?
    @NSManaged public var isDiscoverObject: Bool
    @NSManaged public var isSearchObject: Bool
    @NSManaged public var similar: NSSet?
    @NSManaged public var credits: NSSet?
    @NSManaged public var filmography: NSSet?
    
    public var filmographyArray: [Filmography] {
        let set = filmography as? Set<Filmography> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    
    public var creditsArray: [Person] {
        let set = credits as? Set<Person> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    public var similarMedia: [SimilarMedia] {
        let set = similar as? Set<SimilarMedia> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    var wrappedIMDBUrl: String {
    "https://www.imdb.com/title/\(imdb_id ?? "tt1454468")"
    }
    
    var wrappedTagline: String {
        
        if let tag = tagline {
            if tag == "" {
                return wrappedTitle
            } else {
                return tag
            }
        } else {
            return wrappedTitle
        }
    }
    
    var wrappedStatus: String {
        status ?? "Unknown"
    }
    
    var wrappedPosterImage: UIImage {
        posterImage ?? UIImage(named: "poster_placeholder")!
    }
    
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

// MARK: Generated accessors for credits
extension Media {

    @objc(addCreditsObject:)
    @NSManaged public func addToCredits(_ value: Person)

    @objc(removeCreditsObject:)
    @NSManaged public func removeFromCredits(_ value: Person)

    @objc(addCredits:)
    @NSManaged public func addToCredits(_ values: NSSet)

    @objc(removeCredits:)
    @NSManaged public func removeFromCredits(_ values: NSSet)

}

// MARK: Generated accessors for similarMedia
extension Media {

    @objc(addSimilarMediaObject:)
    @NSManaged public func addToSimilarMedia(_ value: SimilarMedia)

    @objc(removeSimilarMediaObject:)
    @NSManaged public func removeFromSimilarMedia(_ value: SimilarMedia)

    @objc(addSimilarMedia:)
    @NSManaged public func addToSimilarMedia(_ values: NSSet)

    @objc(removeSimilarMedia:)
    @NSManaged public func removeFromSimilarMedia(_ values: NSSet)

}

// MARK: Generated accessors for filmography
extension Media {

    @objc(addFilmographyObject:)
    @NSManaged public func addToFilmography(_ value: Media)

    @objc(removeFilmographyObject:)
    @NSManaged public func removeFromFilmography(_ value: Media)

    @objc(addFilmography:)
    @NSManaged public func addToFilmography(_ values: NSSet)

    @objc(removeFilmography:)
    @NSManaged public func removeFromFilmography(_ values: NSSet)

}

extension Media : Identifiable {

}
