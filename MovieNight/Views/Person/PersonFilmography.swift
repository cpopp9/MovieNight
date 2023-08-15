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
    
    // Set grid size and spacing.
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            LazyVGrid(columns: columns) {
                ForEach(person.filmographyArray) { media in
                    PosterView(media: media)
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
