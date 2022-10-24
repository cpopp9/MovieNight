    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI

struct RecommendedMoviesView: View {
    @FetchRequest var recommendedMedia: FetchedResults<Media>
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            VStack(alignment: .leading) {
                Text("Recommended:")
                    .font(.title.bold())
            }
            
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(recommendedMedia) { media in
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
    
    init(mediaID: String) {
        
        _recommendedMedia = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "filterKey == %@", mediaID))
        
    }
    
}

