    //
    //  DataController.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MovieNight")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
        
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        
        clearMedia(filterKey: "discover")
        
        Task {
            await loadDiscovery(filterKey: "discover", year: nil, page: 1)
        }
        
    }
    
    func detectExistingObjects(item: MediaResult, filterKey: String) {
        let request: NSFetchRequest<Media> = Media.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", item.id)
        
        
        if let object = try? container.viewContext.fetch(request).first {
            object.filterKey = filterKey
        } else {
            CreateMediaObject(item: item, filterKey: filterKey)
        }
    }
    
    func multiSearch(searchText: String) async {
        
        clearMedia(filterKey: "search")
        
        var encoded: String {
            if let encodedText = searchText.stringByAddingPercentEncodingForRFC3986() {
                return encodedText
            } else {
                return "Failed"
            }
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/multi?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&query=\(encoded)&page=1&include_adult=false") else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let searchResults = decodedResponse.results {
                    
                    for item in searchResults {
                        detectExistingObjects(item: item, filterKey: "search")
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func loadDiscovery(filterKey: String, year: Int?, page: Int) async {
        
        let discover = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&primary_release_year=2021&with_watch_monetization_types=flatrate")
        
        
        guard let url = discover else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        detectExistingObjects(item: item, filterKey: filterKey)
                    }
                }
            }
        } catch {
            print("Invalid Data")
        }
        
    }
    
    func clearMedia(filterKey: String) {
        let request = NSFetchRequest<Media>(entityName: "Media")
        request.predicate = NSPredicate(format: "filterKey == %@", filterKey)
        
        do {
            let mediaResults = try container.viewContext.fetch(request)
            
            for media in mediaResults {
                if media.watchlist {
                    media.filterKey = ""
                } else {
                    container.viewContext.delete(media)
                }
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func downloadPoster(media: Media) async {
        
        let url = URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            media.posterImage = UIImage(data: data)
            
        }.resume()
    }
    
    func CreateMediaObject(item: MediaResult, filterKey: String) {
        let newItem = Media(context: container.viewContext)
        newItem.title = item.title ?? item.name ?? "Unknown"
        newItem.id = Int32(item.id)
        newItem.poster_path = item.poster_path ?? item.profile_path
        newItem.media_type = item.media_type ?? "movie"
        newItem.original_language = item.original_language
        newItem.original_title = item.original_title ?? item.original_name
        newItem.overview = item.overview
        newItem.release_date = item.release_date ?? item.first_air_date
        newItem.popularity = item.popularity ?? 0.0
        newItem.watchlist = false
        newItem.watched = false
        newItem.filterKey = filterKey
        newItem.posterImage = UIImage(named: "poster_placeholder")
        
        if let date = item.release_date ?? item.first_air_date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsed = formatter.date(from: date) {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: parsed)
                newItem.release_date = "\(year)"
            }
        }
        
        if let vote_average = item.vote_average {
            newItem.vote_average = vote_average
        }
        
        if let vote_count = item.vote_count {
            newItem.vote_count = Int16(vote_count)
        }
        
        Task {
            await downloadPoster(media: newItem)
        }
    }
}
