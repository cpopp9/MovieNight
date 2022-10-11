    //
    //  MovieSearch.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/7/22.
    //

import SwiftUI

struct MovieSearch: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)]) var searchResults: FetchedResults<SearchMedia>
    
    @State private var prefix = 3
    @State private var moreMovies = false
    
    var body: some View {
        if searchResults.count > 0 {
            
            Section("Movies") {
                ForEach(searchResults.prefix(prefix)) { media in
                    if media.media_type == "movie" {
                        NavigationLink {
                            SearchMediaView(media: media)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(media.wrappedPosterPath)")) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image("poster_placeholder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 75, height: 75)
                                        .overlay(Color.black.opacity(0.8))
                                    
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipped()
                                
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
                if searchResults.count > 3 {
                    Button() {
                        moreMovies ? (prefix = 3) : (prefix = 20)
                        moreMovies.toggle()
                        
                    } label: {
                        HStack {
                            Text(moreMovies ? "See fewer movies" : "See more movies")
                            Spacer()
                            Image(systemName: moreMovies ? "minus" : "plus")
                        }
                    }
                }
            }
        }
    }
}

struct MovieSearch_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearch()
    }
}
