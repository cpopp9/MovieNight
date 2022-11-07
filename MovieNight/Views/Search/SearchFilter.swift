    //
    //  MovieSearch.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/7/22.
    //

import SwiftUI

struct SearchFilter: View {
    
    @FetchRequest var searchResults: FetchedResults<Media>
    var mediaHeadline: String
    
    var body: some View {
        
        if searchResults.count > 0 {
            Section(mediaHeadline) {
                ForEach(searchResults.prefix(3)) { media in
                    NavigationLink {
                        MovieView(media: media)
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(media.poster_path ?? "")")) { image in
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
                    .swipeActions() {
                        Button() {
                            media.watchlist.toggle()
                        } label: {
                            Image(systemName: media.watchlist ? "minus" : "plus")
                        }
                        .tint(media.watchlist ? .red : .green)
                        
                        Button() {
                            media.watched.toggle()
                        } label: {
                            Image(systemName: "eye")
                        }
                        .tint(media.watched ? .purple : .gray)
                        .disabled(!media.watchlist)
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
        }
    }
    
    init(mediaFilter: String) {
        _searchResults = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "isSearchObject == true && media_type == %@", mediaFilter))
        mediaHeadline = mediaFilter
    }
    
    func addMedia(at offsets: IndexSet) {
        for offset in offsets {
            let media = searchResults[offset]
            media.watchlist = true
        }
    }
}



    //struct MovieSearch_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SearchFilter()
    //    }
    //}
