    //
    //  MovieSearch.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/7/22.
    //

import SwiftUI

struct SearchFilter: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest var searchResults: FetchedResults<Movie>
    
    @State private var moreMovies = false
    
    var tvCount: Int
    
    var body: some View {
        if searchResults.count > 0 {
            Section("Movies") {
                ForEach(searchResults.prefix(3)) { media in
                    if media.media_type == "movie" {
                        NavigationLink {
                            MovieView(media: media)
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
            }
            
            Section("TV Shows") {
                ForEach(searchResults.prefix(3)) { media in
                    if media.media_type == "tv" {
                        
                        NavigationLink {
                            MovieView(media: media)
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
                    NavigationLink {
                        AllSearchMoviesView(searchResults: searchResults, mediaType: "tv")
                        
                    } label: {
                        HStack {
                            Text("More TV Shows")
                            Spacer()
                            Text(String(tvCount))
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
    
    init(tvCounter: Int) {
        _searchResults = FetchRequest<Movie>(sortDescriptors: [], predicate: NSPredicate(format: "isSearchMedia == true"))
        
        tvCount = tvCounter
    }
}

//struct MovieSearch_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchFilter()
//    }
//}
