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
        VStack {
            Text("Recommended:")
                .font(.title.bold())
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(recommendedMedia) { media in
                        NavigationLink {
                            MovieView(media: media)
                        } label: {
                            Image(uiImage: media.wrappedPosterImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
        }
    }
    
    init(mediaID: String) {
        
        _recommendedMedia = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "filterKey == %@", mediaID))
        
    }
    
}

