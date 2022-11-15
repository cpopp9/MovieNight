    //
    //  PersonFilmography.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/25/22.
    //

import SwiftUI

struct PersonFilmography: View {

    @EnvironmentObject var dataController: DataController
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
                await dataController.downloadPersonFilmography(person: person)
            }
        }
    }
}

    struct PersonFilmography_Previews: PreviewProvider {
        static var previews: some View {
            PersonFilmography(person: Person())
        }
    }
