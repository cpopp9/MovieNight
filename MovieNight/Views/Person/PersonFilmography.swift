    //
    //  PersonFilmography.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/25/22.
    //

import SwiftUI

struct PersonFilmography: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var person: Person
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Filmography \(person.filmographyArray.count):")
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns) {
                ForEach(person.filmographyArray) { media in
                    FilmographyPostersView(media: media)
                }
            }
            .padding(.horizontal)
        }
        .task {
            if person.filmographyArray.isEmpty {
                await downloadPersonFilmography(person: person)
            }
        }
    }
    
    func downloadPersonFilmography(person: Person) async {
        
        let discover = URL(string: "https://api.themoviedb.org/3/person/\(person.id)/movie_credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US")
        
        guard let url = discover else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let filmographyResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let filmographyResults = filmographyResponse.cast {
                    
                    for item in filmographyResults {
                        person.addToFilmography(dataController.CreateMediaObject(item: item, context: moc))
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
    }
    
    
}

struct PersonFilmography_Previews: PreviewProvider {
    static var previews: some View {
        PersonFilmography(person: Person())
    }
}
