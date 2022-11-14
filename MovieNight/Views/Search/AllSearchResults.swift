    //
    //  AllSearchMoviesView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/13/22.
    //

import SwiftUI

struct AllSearchResults: View {
    let allMedia: [Media]
    
    var body: some View {
        List {
            ForEach(allMedia) { media in
                NavigationLink {
                    MovieView(media: media)
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(media.wrappedPosterPath)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipped()
                            
                        } placeholder: {
                            Image("poster_placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipped()
                        }
                        
                        VStack(alignment: .leading) {
                            Text(media.wrappedTitle)
                                .font(.headline)
                            Text(media.wrappedReleaseDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("All Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//    struct AllSearchResults_Previews: PreviewProvider {
//        static var previews: some View {
//            AllSearchResults(searchResults: <#T##FetchedResults<Movie>#>)
//        }
//    }
