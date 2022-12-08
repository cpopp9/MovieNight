//
//  DiscoverVM.swift
//  MovieNight
//
//  Created by Cory Popp on 12/8/22.
//

import Foundation
import CoreData

@MainActor class DiscoverViewModel: MediaModel {
    
    @Published var currentPage = 1
    
    func downloadDiscoveryMedia(year: Int, page: Int, context: NSManagedObjectContext) async {
        
        guard let discover = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&primary_release_year=\(year)&with_watch_monetization_types=flatrate") else {
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
    }
}
