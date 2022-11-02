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
    @FetchRequest var similarMedia: FetchedResults<SimilarMedia>
    
    
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
                        ForEach(similarMedia, id: \.self) { similar in
                            ForEach(similar.similarMedia) { media in
                                SimilarPostersView(media: media)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    init(similarTo: Int) {
        _similarMedia = FetchRequest<SimilarMedia>(sortDescriptors: [], predicate: NSPredicate(format: "id == %i", similarTo))
    }
}

