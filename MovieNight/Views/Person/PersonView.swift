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
            if person.biography == nil {
                await downloadAdditionalPersonDetails(person: person)
            }
        }
    }
    
        // Downloads additional information about a person and assigns it to their existing core data object
    
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
    
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(person: Person())
    }
}
