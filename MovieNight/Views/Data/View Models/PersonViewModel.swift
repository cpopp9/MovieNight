//
//  PersonViewModel.swift
//  MovieNight
//
//  Created by Cory Popp on 12/8/22.
//

import Foundation
import CoreData

@MainActor class PersonViewModel: MediaViewModel {
    
    func CreatePerson(person: Cast, context: NSManagedObjectContext) -> Person {
        let newPerson = Person(context: context)
        newPerson.name = person.name
        newPerson.credit_id = person.credit_id
        newPerson.popularity = person.popularity
        newPerson.profile_path = person.profile_path
        newPerson.knownFor = person.known_for_department
        newPerson.id = Int(person.id)
        
        return newPerson
    }
    
    func downloadPersonFilmography(person: Person, context: NSManagedObjectContext) async {
        
        let discover = URL(string: "https://api.themoviedb.org/3/person/\(person.id)/movie_credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US")
        
        guard let url = discover else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let filmographyResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let filmographyResults = filmographyResponse.cast {
                    
                    for item in filmographyResults {
                        person.addToFilmography(createMediaObject(item: item, context: context))
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
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
                
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
    }
    
    func downloadMediaCredits(media: Media, context: NSManagedObjectContext) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try?  JSONDecoder().decode(Credits.self, from: data) {
                
                if let cast = decodedResponse.cast {
                    for person in cast {
                        if person.profile_path == nil { break }
                        media.addToCredits(CreatePerson(person: person, context: context))
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
    }
    
}
