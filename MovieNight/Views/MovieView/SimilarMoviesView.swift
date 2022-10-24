    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI

struct SimilarMoviesView: View {
    @FetchRequest var similarMedia: FetchedResults<Media>
    
    var body: some View {
        
        if similarMedia.count > 0 {
            VStack(alignment: .leading) {
                
                
                VStack(alignment: .leading) {
                    Text("You might also like")
                        .font(.title.bold())
                }
                
                .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(similarMedia) { media in
                            NavigationLink {
                                MovieView(media: media)
                            } label: {
                                Image(uiImage: media.wrappedPosterImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    init(mediaID: String) {
        
        _similarMedia = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "filterKey == %@", mediaID))
        
    }
    
}

