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
    lazy var container = NSPersistentContainer(name: "MovieNight")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
        
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        
        deleteMediaObjects()
        
        Task {
            await loadDiscovery(filterKey: "discover", year: 2022, page: 1)
        }
        
    }
    
        // Enums
    
    enum DeleteFilter {
        case all, nonWatchlist
    }
    
    enum ClearFilter {
        case search, discover, all
    }
    
    enum DetectFilter {
        case search, discover, similar
    }
    
        // API Requests
    
    func multiSearch(searchText: String) async {
        
        clearMedia(filter: .search)
        
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
                        if let existing = detectExistingMedia(mediaID: item.id) {
                            existing.isSearchObject = true
                        } else {
                            CreateMediaObject(item: item, filter: .search)
                        }
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func loadDiscovery(filterKey: String, year: Int, page: Int) async {
        
        let discover = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&primary_release_year=\(year)&with_watch_monetization_types=flatrate")
        
        
        guard let url = discover else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        if let existing = detectExistingMedia(mediaID: item.id) {
                            existing.isDiscoverObject = true
                        } else {
                            CreateMediaObject(item: item, filter: .discover)
                        }
                    }
                }
            }
        } catch {
            print("Invalid Data")
        }
        
            await saveMedia()
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
    
    func loadSimilarMedia(media: Media) async {
        
        var similarMedia = [Media]()
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/recommendations?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        if let existing = detectExistingMedia(mediaID: item.id) {
                            similarMedia.append(existing)
                        } else {
                            if let new = CreateMediaObject(item: item, filter: .similar) {
                                similarMedia.append(new)
                            }
                        }
                    }
                }
            }
            
        } catch {
            print("Invalid Data")
        }
        writeToSimilarMedia(media: media, similarMedia: similarMedia)
        await saveMedia()
        print("similar movies loaded")
    }
    
    func writeToSimilarMedia(media: Media, similarMedia: [Media]) {
        let similar = SimilarMedia(context: container.viewContext)
        similar.id = media.id
        similar.title = media.title
        
        for media in similarMedia {
            similar.addToMedia(media)
        }
    }
    
    func getCredits(media: Media) async {
        
        var credits = [Person]()
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Credits.self, from: data) {
                
                if let cast = decodedResponse.cast {
                    for person in cast {
                        
                        
                            //                        if let existing = detectExistingPerson(personID: Int(person.id)) {
                            //                            credits.append(existing)
                            //                        } else {
                        let new = CreatePerson(person: person, media: media)
                        credits.append(new)
                        
                            //                        }
                            //                        }
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
        writeToCredits(media: media, credits: credits)
    }
    
    func additionalPersonDetails(person: Person) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(person.id)?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(PersonResult.self, from: data) {
                
                person.biography = decodedResponse.biography
                person.place_of_birth = decodedResponse.place_of_birth
                person.birthday = decodedResponse.birthday
                    //                person.deathday = decodedResponse.deathday
                
            }
        } catch {
            print("Invalid Data")
        }
    }
    
    func writeToCredits(media: Media, credits: [Person]) {
        let newCredits = Person(context: container.viewContext)
        newCredits.mediaCredit = Int(media.id)
        
        for person in credits {
            newCredits.addToMedia(media)
        }
    }
    
        // Media Download
    
    func downloadPoster(media: Media) async {
        
        let url = URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            media.posterImage = UIImage(data: data)
            
        }.resume()
    }
    
    func downloadProfile(person: Person) async {
        
        let url = URL(string: "https://image.tmdb.org/t/p/w342\(person.wrappedProfilePath)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            person.profileImage = UIImage(data: data)
            
        }.resume()
    }
    
        // Object Functions
    
    func detectExistingMedia(mediaID: Int) -> Media? {
        let request: NSFetchRequest<Media> = Media.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", mediaID)
        
        if let object = try? container.viewContext.fetch(request).first {
            return object
        }
        
        return nil
    }
    
    func detectExistingPerson(personID: Int) -> Person? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", personID)
        
        if let person = try? container.viewContext.fetch(request).first {
            return person
        }
        return nil
    }
    
    func CreateMediaObject(item: MediaResult, filter: DetectFilter) -> Media? {
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
        newItem.posterImage = UIImage(named: "poster_placeholder")
        
        if filter == .discover {
            newItem.isDiscoverObject = true
        }
        
        if filter == .search {
            newItem.isSearchObject = true
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
        return newItem
    }
    
    func CreatePerson(person: Cast, media: Media) -> Person {
        let newPerson = Person(context: container.viewContext)
        newPerson.name = person.name
        newPerson.credit_id = person.credit_id
        newPerson.popularity = person.popularity
        newPerson.profile_path = person.profile_path
        newPerson.knownFor = person.known_for_department
        newPerson.id = Int(person.id)
        newPerson.mediaCredit = Int(media.id)
        
        Task {
            await downloadProfile(person: newPerson)
        }
        
        return newPerson
    }
    
        // Persistent Store Functions
    
    func saveMedia() async {
        
        await MainActor.run {
            do {
                try container.viewContext.save()
                print("Context Saved")
                
            } catch let error {
                print("Persistent Store Not Saved \(error)")
            }
        }
    }
    
    func clearMedia(filter: ClearFilter) {
        let request = NSFetchRequest<Media>(entityName: "Media")
        
        do {
            let mediaResults = try container.viewContext.fetch(request)
            
            for media in mediaResults {
                if filter == .search {
                    media.isSearchObject = false
                } else if filter == .discover {
                    media.isDiscoverObject = false
                    
                    
                } else if filter == .all {
                    media.isSearchObject = false
                    media.isDiscoverObject = false
                }
            }
            
        } catch let error {
            print("Error fetching media to clear. \(error)")
        }
    }
    
    func deleteMediaObjects() {
        let mediaRequest = NSFetchRequest<Media>(entityName: "Media")
        let peopleRequest = NSFetchRequest<Person>(entityName: "Person")
        let similarRequest = NSFetchRequest<SimilarMedia>(entityName: "SimilarMedia")
        
        do {
            let mediaResults = try container.viewContext.fetch(mediaRequest)
            let personResults = try container.viewContext.fetch(mediaRequest)
            let similarResults = try container.viewContext.fetch(similarRequest)
            
            for media in mediaResults {
                if !media.watchlist {
                    container.viewContext.delete(media)
                }
            }
            
            for person in personResults {
                    container.viewContext.delete(person)
            }
            
            for similar in similarResults {
                    container.viewContext.delete(similar)
            }
            
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
}
