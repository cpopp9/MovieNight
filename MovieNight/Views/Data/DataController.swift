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
        
        deleteAllObjects()
        
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
    
    func downloadSearchMedia(searchText: String) async {
        
        clearMedia(filter: .search)
        
        var newMedia = [MediaResult]()
        
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
                            newMedia.append(item)
                        }
                    }
                    
                    for item in newMedia {
                        CreateMediaObject(item: item, filter: .search)
                    }
                }
            }
        } catch let error {
            fatalError("Invalid Data \(error)")
        }
        await saveMedia()
        print("Search Media Loaded")
    }
    
    func downloadDiscoveryMedia(filterKey: String, year: Int, page: Int) async {
        
        var newMedia = [MediaResult]()
        
        let discover = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&primary_release_year=\(year)&with_watch_monetization_types=flatrate")
        
        
        guard let url = discover else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if var discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        if let existing = detectExistingMedia(mediaID: item.id) {
                            existing.isDiscoverObject = true
                        } else {
                            newMedia.append(item)
                        }
                    }
                    
                    for item in newMedia {
                        CreateMediaObject(item: item, filter: .discover)
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
        
        await saveMedia()
        print("Discovery Media Loaded")
    }
    
    func downloadAdditionalMediaDetails(media: Media) async {
        
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
        } catch let error {
            print("Invalid Data \(error)")
        }
        print("Additional Media Details Loaded")
        await saveMedia()
    }
    
    func downloadSimilarMedia(media: Media) async {
        
        var newItem = [MediaResult]()
        
        
        let similar = SimilarMedia(context: container.viewContext)
        similar.id = media.id
        similar.title = media.title
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/recommendations?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let similarResults = decodedResponse.results {
                    
                    for item in similarResults {
                        if item.poster_path == nil { break }
                        
                        if let existing = detectExistingMedia(mediaID: item.id) {
                            similar.addToMedia(existing)
                        } else {
                            newItem.append(item)
                        }
                    }
                    
                    for item in newItem {
                        if let new = CreateMediaObject(item: item, filter: .similar) {
                            similar.addToMedia(new)
                        }
                    }
                }
            }
            
        } catch let error {
            print("Invalid Data \(error)")
        }
        await saveMedia()
        print("Similar Movies Loaded")
    }
    
    func downloadPersonFilmography(person: Person) async {
        
        var newMedia = [MediaResult]()
        
        let filmography = Filmography(context: container.viewContext)
        filmography.personID = Int64(person.id)
        filmography.name = person.wrappedName
        
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(person.id)/movie_credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.cast {
                    
                    for item in discoverResults {
                        
                        if item.poster_path == nil { break }
                        
                        for item in discoverResults {
                            if let existing = detectExistingMedia(mediaID: item.id) {
                                filmography.addToMedia(existing)
                                await saveMedia()
                            } else {
                                newMedia.append(item)
                            }
                        }
                        
                        for item in newMedia {
                            if let media = CreateMediaObject(item: item, filter: .similar) {
                                filmography.addToMedia(media)
                            }
                        }
                    }
                }
            }
            
        } catch let error {
            print("Invalid Data \(error)")
        }
        
        await saveMedia()
        print("Person Filmography Loaded")
    }
    
    func downloadMediaCredits(media: Media) async {
        
        var newCredits = [Person]()
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Credits.self, from: data) {
                
                if let cast = decodedResponse.cast {
                    for person in cast {
                        if person.profile_path == nil { break }
                        
                        newCredits.append(CreatePerson(person: person, media: media))
                        
                    }
                    
                    for person in newCredits {
                        person.addToMedia(media)
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
        print("Media Credits Loaded")
    }
    
    func downloadAdditionalPersonDetails(person: Person) async {
        
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
        } catch let error {
            print("Invalid Data \(error)")
        }
        print("Additional Person Details Loaded")
    }
    
    func downloadPoster(media: Media) async {
        
        DispatchQueue.main.async {
            
            let url = URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)")!
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                media.posterImage = UIImage(data: data)
                
            }.resume()
        }
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
    
    func CreateMediaObject(item: MediaResult, filter: DetectFilter) -> Media? {
        let newItem = Media(context: container.viewContext)
        newItem.title = item.title ?? item.name ?? "Unknown"
        newItem.id = Int32(item.id)
        newItem.poster_path = item.poster_path ?? item.profile_path
        newItem.media_type = item.media_type ?? "movie"
        newItem.original_language = item.original_language
        newItem.overview = item.overview
        newItem.release_date = item.release_date ?? item.first_air_date
        newItem.popularity = item.popularity ?? 0.0
        newItem.watchlist = false
        newItem.watched = false
        newItem.posterImage = UIImage(named: "poster_placeholder")
        newItem.timeAdded = Date.now
        
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
        
            //        Task {
            //            await downloadPoster(media: newItem)
            //        }
        
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
        
        return newPerson
    }
    
        // Persistent Store Functions
    
    func saveMedia() async {
        
        DispatchQueue.main.async {
            do {
                try self.container.viewContext.save()
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
    
    func deleteNonWatchlistMedia() {
        let mediaRequest = NSFetchRequest<Media>(entityName: "Media")
        
        do {
            let mediaResults = try container.viewContext.fetch(mediaRequest)
            
            for media in mediaResults {
                if !media.watchlist {
                    container.viewContext.delete(media)
                }
            }
            
        } catch let error {
            print("Error fetching. \(error)")
            
        }
        Task {
            await saveMedia()
        }
    }
    
    func deleteAllObjects() {
        let mediaRequest = NSFetchRequest<Media>(entityName: "Media")
        let personRequest = NSFetchRequest<Person>(entityName: "Person")
        let similarRequest = NSFetchRequest<SimilarMedia>(entityName: "SimilarMedia")
        let filmography = NSFetchRequest<Filmography>(entityName: "Filmography")
        
        do {
            let mediaResults = try container.viewContext.fetch(mediaRequest)
            let personResults = try container.viewContext.fetch(personRequest)
            let similarResults = try container.viewContext.fetch(similarRequest)
            let filmographyResults = try container.viewContext.fetch(filmography)
            
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
            
            for media in filmographyResults {
                container.viewContext.delete(media)
            }
            
        } catch let error {
            print("Error fetching. \(error)")
        }
        Task {
            await saveMedia()
        }
    }
    
        // archived functions
    
        //    func downloadProfile(person: Person) async {
        //
        //        let url = URL(string: "https://image.tmdb.org/t/p/w342\(person.wrappedProfilePath)")!
        //
        //        URLSession.shared.dataTask(with: url) { data, _, error in
        //            guard let data = data, error == nil else {
        //                return
        //            }
        //
        //            person.profileImage = UIImage(data: data)
        //
        //        }.resume()
        //    }
    
        //    func writeToCredits(media: Media, credits: [Person]) {
        //        let newCredits = Person(context: container.viewContext)
        //        newCredits.mediaCredit = Int(media.id)
        //
        //        for person in credits {
        //            newCredits.addToMedia(media)
        //        }
        //    }
    
}
