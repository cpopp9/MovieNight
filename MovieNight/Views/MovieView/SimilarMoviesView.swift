    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI
import CoreData

struct SimilarMoviesView: View {
    @StateObject var similarVM = SimilarViewModel()
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var media: Media
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if !media.similarArray.isEmpty {
                
                Text("You might also like")
                    .font(.title.bold())
                    .padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(media.similarArray) { media in
                            SimilarPostersView(media: media)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.bottom, 20)
        .task {
            if media.similarArray.isEmpty {
                await similarVM.downloadSimilarMedia(media: media, context: moc)
            }
        }
    }
}

struct SimilarMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        SimilarMoviesView(media: Media())
    }
}

