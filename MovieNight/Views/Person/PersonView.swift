    //
    //  PersonView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/25/22.
    //

import SwiftUI

struct PersonView: View {
    @ObservedObject var person: Person
    @EnvironmentObject var personVM: PersonViewModel
    
    var body: some View {
        ScrollView {
            PersonDetails(person: person)
            PersonFilmography(person: person)
        }
        .task {
            if person.biography == nil {
                await personVM.downloadAdditionalPersonDetails(person: person)
            }
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(person: Person())
    }
}
