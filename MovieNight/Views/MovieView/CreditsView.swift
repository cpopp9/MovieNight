    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI
import CoreData

struct CreditsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var media: Media
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if !media.creditsArray.isEmpty {
                
                Text("Credits")
                    .font(.title.bold())
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 15) {
                        ForEach(media.creditsArray.prefix(10)) { person in
                            CreditProfilePictures(person: person)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .task {
            if media.creditsArray.isEmpty {
                await downloadMediaCredits(media: media)
            }
        }
    }
    
    
    func downloadMediaCredits(media: Media) async {
        
        
        
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
                        media.addToCredits(dataController.CreatePerson(person: person))
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
        dataController.saveMedia(context: moc)
    }
}


struct CreditsView_Previes: PreviewProvider {
    static var previews: some View {
        MovieDetailView(media: Media())
    }
}
