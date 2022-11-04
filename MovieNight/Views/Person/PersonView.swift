//
//  PersonView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/25/22.
//

import SwiftUI

struct PersonView: View {
    @ObservedObject var person: Person
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ScrollView {
            PersonDetails(person: person)
            PersonFilmography(person: person)
        }
        .task {
            await dataController.additionalPersonDetails(person: person)
        }
    }
}

//struct PersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonView()
//    }
//}
