    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI
import CoreData

struct SimilarMoviesView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var media: Media
    
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("You might also like")
                        .font(.title.bold())
                        .padding(.horizontal)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(media.similarArray) { media in
                                SimilarPostersView(media: media)
//                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .task {
//            if media.similarArray.isEmpty {
                await dataController.downloadSimilarMedia(media: media)
//            }
        }
    }
}

