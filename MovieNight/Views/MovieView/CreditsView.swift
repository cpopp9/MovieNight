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
                await dataController.downloadMediaCredits(media: media)
            }
        }
    }
}


struct CreditsView_Previes: PreviewProvider {
    static var previews: some View {
        MovieDetailView(media: Media())
    }
}
