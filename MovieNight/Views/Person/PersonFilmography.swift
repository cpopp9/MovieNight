    //
    //  PersonFilmography.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/25/22.
    //

import SwiftUI

struct PersonFilmography: View {
    @FetchRequest var filmography: FetchedResults<Filmography>
    @EnvironmentObject var dataController: DataController
    @ObservedObject var person: Person
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Filmography:")
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns) {
                ForEach(filmography) { filmography in
                    ForEach(filmography.similarMedia) { media in
                        FilmographyPostersView(media: media)
                    }
                }
            }
            .padding(.horizontal)
        }
        .task {
            if filmography.isEmpty {
                await dataController.downloadPersonFilmography(person: person)
            }
        }
    }
    
    init(person: Person) {
        _filmography = FetchRequest<Filmography>(sortDescriptors: [], predicate: NSPredicate(format: "personID == %i", person.id, person.wrappedName))
        self.person = person
    }
    
}

    //struct PersonFilmography_Previews: PreviewProvider {
    //    static var previews: some View {
    //        PersonFilmography(dataController: DataController)
    //    }
    //}
