    //
    //  SearchVM.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 12/8/22.
    //

import Foundation
import CoreData

@MainActor class SearchViewModel: MediaViewModel {
    
    var searchText = ""
    
    var searchURL: String {
        "https://api.themoviedb.org/3/search/multi?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&query=\(searchText.formatQuery())&page=1&include_adult=false"
    }
    
    func downloadSearchMedia(context: NSManagedObjectContext) async {
        
        clearSearch(context: context)
        
        guard let url = URL(string: searchURL) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let searchResults = decodedResponse.results {
                    
                    for item in searchResults {
                        createMediaObject(item: item, context: context).isSearchObject = true
                    }
                }
            }
        } catch let error {
            fatalError("Invalid Data \(error)")
        }
        saveMedia(context: context)
    }
    
}
