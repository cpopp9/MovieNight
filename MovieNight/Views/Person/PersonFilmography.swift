    //
    //  PersonFilmography.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/25/22.
    //

import SwiftUI

struct PersonFilmography: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var person: Person
    @EnvironmentObject var personVM: PersonViewModel
    
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
                await personVM.downloadPersonFilmography(person: person, context: moc)
            }
        }
    }
}

struct PersonFilmography_Previews: PreviewProvider {
    static var previews: some View {
        PersonFilmography(person: Person())
    }
}
