//
//  DiscoverVM.swift
//  MovieNight
//
//  Created by Cory Popp on 12/8/22.
//

import Foundation
import CoreData

@MainActor class DiscoverViewModel: MediaViewModel {
    
    @Published var pageCount = 1
    
    enum DecadeRange {
        case fifties, sixties, seventies, eighties, nineties, twoThousands, twentyTens, current
    }
    
    var selectedRange = DecadeRange.current
    
    var dateRange: String {
        
        switch selectedRange {
        case .current:
            return ""
        case .twentyTens:
            return "&primary_release_date.gte=2010-01-01&primary_release_date.lte=2019-12-31"
        case .twoThousands:
            return "&primary_release_date.gte=2000-01-01&primary_release_date.lte=2009-12-31"
        case .nineties:
            return "&primary_release_date.gte=1990-01-01&primary_release_date.lte=1999-12-31"
        case .eighties:
            return "&primary_release_date.gte=1980-01-01&primary_release_date.lte=1989-12-31"
        case .seventies:
            return "&primary_release_date.gte=1970-01-01&primary_release_date.lte=1979-12-31"
        case .sixties:
            return "&primary_release_date.gte=1960-01-01&primary_release_date.lte=1969-12-31"
        case .fifties:
            return "&primary_release_date.gte=1950-01-01&primary_release_date.lte=1959-12-31"
        }
    }
    
    let mediaType = ["movie", "tv"]
    
    let selectedLanguages = ["en"]
    
    var selectedMediaType = "movie"
    
    var selectedSortBy = "popularity.desc"
    
    var selectedLanguage = "en-US"
    
    let apiKey = "9cb160c0f70956da44963b0444417ee2"
    
    var subHeading = "New and upcoming releases"
    
    var baseURL: String {  "https://api.themoviedb.org/3/discover/\(selectedMediaType)?api_key=\(apiKey)&language=\(selectedLanguage)&sort_by=\(selectedSortBy)&include_adult=false&include_video=false&page=\(pageCount)\(dateRange)&with_watch_monetization_types=flatrate"
    }
    
    func downloadDiscoveryMedia(context: NSManagedObjectContext) async {
        
        guard let discover = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: discover)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        createMediaObject(item: item, context: context).isDiscoverObject = true
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
        saveMedia(context: context)
        pageCount += 1
    }
    
}
