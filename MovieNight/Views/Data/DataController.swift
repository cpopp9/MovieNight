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
        
        clearMedia(clearDiscover: true, clearSearch: true)
        
        Task {
            await loadDiscovery(filterKey: "discover", year: nil, page: 1)
        }
        
    }
    
    func detectExistingObjects(item: MediaResult, filterKey: String, isDiscoverObject: Bool?, isSearchObject: Bool?) {
        let request: NSFetchRequest<Media> = Media.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", item.id)
        
        
        if let object = try? container.viewContext.fetch(request).first {
            object.filterKey = filterKey
            
            if let isDiscoverObject = isDiscoverObject {
                object.isDiscoverObject = isDiscoverObject
            }
            
            if let isSearchObject = isSearchObject {
                object.isSearchObject = isSearchObject
            }
        } else {
            CreateMediaObject(item: item, filterKey: filterKey, isDiscoverObject: isDiscoverObject, isSearchObject: isSearchObject)
        }
    }
    
    func multiSearch(searchText: String) async {
        
        clearMedia(clearDiscover: false, clearSearch: true)
        
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
                        detectExistingObjects(item: item, filterKey: "search", isDiscoverObject: nil, isSearchObject: true)
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func saveMedia() {
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Persistent Store Not Saved")
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
                        detectExistingObjects(item: item, filterKey: filterKey, isDiscoverObject: true, isSearchObject: nil)
                    }
                }
            }
        } catch {
            print("Invalid Data")
        }
        
    }
    
    func clearMedia(clearDiscover: Bool, clearSearch: Bool) {
        let request = NSFetchRequest<Media>(entityName: "Media")
        request.predicate = NSPredicate(format: "(isDiscoverObject == %@) || (isSearchObject == %@)", NSNumber(value: clearDiscover), NSNumber(value: clearSearch))
        
        
        do {
            let mediaResults = try container.viewContext.fetch(request)
            
            for media in mediaResults {
                if media.watchlist {
                    
                    if clearDiscover {
                        media.isDiscoverObject = false
                    }
                    
                    if clearSearch {
                        media.isSearchObject = false
                    }
                    
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
    
    func CreateMediaObject(item: MediaResult, filterKey: String, isDiscoverObject: Bool?, isSearchObject: Bool?) {
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
        
        if let isDiscoverObject = isDiscoverObject {
            newItem.isDiscoverObject = isDiscoverObject
        }
        
        if let isSearchObject = isSearchObject {
            newItem.isSearchObject = isSearchObject
        }
        
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
    
    func additionalMediaDetails(media: Media) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaDetails.self, from: data) {
                
                media.imdb_id = decodedResponse.imdb_id
                media.runtime = Int16(decodedResponse.runtime ?? 0)
                media.tagline = decodedResponse.tagline
                media.status = decodedResponse.status
                
            }
        } catch {
            print("Invalid Data")
        }
    }
    
    func mediaRecommendations(media: Media) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/recommendations?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        detectExistingObjects(item: item, filterKey: String(media.id), isDiscoverObject: nil, isSearchObject: nil)
                    }
                }
            }
            
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func getCredits(media: Media) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Credits.self, from: data) {
                
                if let cast = decodedResponse.cast {
                    for person in cast {
                        
                        if detectExistingPerson(credit_id: person.credit_id) {
                            
                        } else {
                            let newPerson = Person(context: container.viewContext)
                            newPerson.name = person.name
                            newPerson.credit_id = person.credit_id
                            newPerson.popularity = person.popularity
                            newPerson.profile_path = person.profile_path
                        }
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func detectExistingPerson(credit_id: String) -> Bool {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "credit_id == %@", credit_id)
        
        if let person = try? container.viewContext.fetch(request).first {
            return true
        } else {
            return false
        }
    }
    
}
