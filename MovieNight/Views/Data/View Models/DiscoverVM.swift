//
//  DiscoverVM.swift
//  MovieNight
//
//  Created by Cory Popp on 12/8/22.
//

import Foundation
import CoreData

@MainActor class DiscoverViewModel: MediaModel {
    
    @Published var pageCount = 1
    
    
    var dateRange = "&primary_release_date.gte=1990-01-01&primary_release_date.lte=1999-12-31"
    
    
    var decades: [String] = [
        
        // Current
        "2020", "2029",
        
        // 2010's
        "2010", "2019",
        
        // 2000's
        "2000", "2009",
        
        // 90's
        "1990", "1999",
        
        // 80's
        "1980", "1989",
        
        // 70's
        "1970", "1979",
        
        // 60's
        "1960", "1969",
        
        // 50's
        "1950", "1959"
        
    ]
    
    let mediaType = ["movie", "tv"]
    
    let selectedLanguages = ["en"]
    
    var selectedMediaType = "movie"
    
    var selectedSortBy = "popularity.desc"
    
    var selectedLanguage = "en-US"
    
    let apiKey = "9cb160c0f70956da44963b0444417ee2"
    
    var subHeading = "New and upcoming releases"
    
    
    var baseURL: String {  "https://api.themoviedb.org/3/discover/\(selectedMediaType)?api_key=\(apiKey)&language=\(selectedLanguage)&sort_by=\(selectedSortBy)&include_adult=false&include_video=false&page=\(pageCount)\(dateRange)&with_watch_monetization_types=flatrate"
    }
    
    func downloadDiscoveryMedia(year: Int, page: Int, context: NSManagedObjectContext) async {
        
        guard let discover = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }
        
//        guard let discover = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&primary_release_year=2022&with_watch_monetization_types=flatrate") else {
//            print("Invalid URL")
//            return
//        }
        
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
    }
}
