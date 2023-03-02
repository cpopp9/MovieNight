    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI
import CoreData

struct CreditsView: View {
    @EnvironmentObject var personVM: PersonViewModel
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
        .padding(.bottom, 10)
        .task {
            if media.creditsArray.isEmpty {
                await personVM.downloadMediaCredits(media: media, context: moc)
            }
        }
    }
}


struct CreditsView_Previes: PreviewProvider {
    static var previews: some View {
        MediaDetailView(media: Media())
    }
}
