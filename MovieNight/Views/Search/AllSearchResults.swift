    //
    //  AllSearchMoviesView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/13/22.
    //

import SwiftUI

struct AllSearchResults: View {
    var searchResults: FetchedResults<Movie>
    
    var body: some View {
        List {
            ForEach(searchResults) { media in
                NavigationLink {
                    MovieView(media: media)
                } label: {
                    HStack {
                        if let poster = media.posterImage {
                            Image(uiImage: poster)
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
