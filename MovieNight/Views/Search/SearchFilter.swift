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
    
    var body: some View {
            ForEach(searchResults.prefix(3)) { media in
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
            
            NavigationLink {
                AllSearchResults(searchResults: searchResults)
            } label: {
                HStack {
                    Text("See More")
                    Spacer()
                    Text(String(searchResults.count))
                    Image(systemName: "plus")
                }
            }
    }
    
    init(mediaFilter: String) {
        _searchResults = FetchRequest<Movie>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "isSearchMedia == true && media_type == %@", mediaFilter))
    }
}



    //struct MovieSearch_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SearchFilter()
    //    }
    //}
