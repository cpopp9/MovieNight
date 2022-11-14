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
        
        VStack(alignment: .leading) {
            
            if !media.similarArray.isEmpty {
                
                Text("You might also like \(media.similarArray.count)")
                    .font(.title.bold())
                    .padding(.horizontal)
                
                
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
            if media.similarArray.count < 5 {
                await dataController.downloadSimilarMedia(media: media)
            }
        }
    }
}

