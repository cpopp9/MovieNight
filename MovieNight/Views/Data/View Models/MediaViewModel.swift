//
//  MediaModel.swift
//  MovieNight
//
//  Created by Cory Popp on 12/4/22.
//
import CoreData
import Foundation
import UIKit

@MainActor class MediaViewModel: ObservableObject {
    
    let APIKEY = "9cb160c0f70956da44963b0444417ee2"
    
    enum DeleteFilter {
        case all, discover, nonWatchlist
    }
    
    func createMediaObject(item: MediaResult, context: NSManagedObjectContext) -> Media {
        let newItem = Media(context: context)
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
        
            downloadPoster(media: newItem)
        
        return newItem
    }
    
    func downloadPoster(media: Media) {
        
        // Poster sizes - w92, w154, w185, w342, w500, w780, original

            let url = URL(string: "https://image.tmdb.org/t/p/w92\(media.wrappedPosterPath)")!
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                media.posterImage = UIImage(data: data)
                
            }.resume()
    }
    
    func saveMedia(context: NSManagedObjectContext) {
            do {
                try context.save()
                print("Context Saved")
                
            } catch let error {
                print("Persistent Store Not Saved \(error)")
            }
    }
    
    func clearSearch(context: NSManagedObjectContext) {
        let request = NSFetchRequest<Media>(entityName: "Media")
        
        do {
            let mediaResults = try context.fetch(request)
            
            for media in mediaResults {
                media.isSearchObject = false
            }
            
        } catch let error {
            print("Error fetching media to clear. \(error)")
        }
    }
    
    func deleteObjects(filter: DeleteFilter, context: NSManagedObjectContext) {
        let mediaRequest = NSFetchRequest<Media>(entityName: "Media")
        let personRequest = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            let mediaResults = try context.fetch(mediaRequest)
            let personResults = try context.fetch(personRequest)
            
            
            if filter == .all {
                for media in mediaResults {
                    context.delete(media)
                }
            } else if filter == .discover {
                for media in mediaResults {
                    if media.watchlist == false {
                        context.delete(media)
                    } else {
                        media.isDiscoverObject = false
                    }
                }
            } else if filter == .nonWatchlist {
                for media in mediaResults {
                    if media.watchlist {
                        media.isDiscoverObject = false
                    }
                }
            }
            
            for person in personResults {
                context.delete(person)
            }
            
        } catch let error {
            print("Error fetching. \(error)")
        }
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
                media.number_of_seasons = Int16(decodedResponse.number_of_seasons ?? 0)
                
                if let genres = decodedResponse.genres {
                    var genString = [String]()
                    
                    for genre in genres {
                        genString.append(genre.name)
                    }
                    
                    media.genres = genString.joined(separator: ", ")
                }
                
                
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
    }
}
