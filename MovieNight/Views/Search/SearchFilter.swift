    //
    //  MovieSearch.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/7/22.
    //

import SwiftUI

struct SearchFilter: View {
    
    @FetchRequest var searchResults: FetchedResults<Movie>
    
    var body: some View {
            ForEach(searchResults.prefix(3)) { media in
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
    
    init(mediaFilter: String) {
        _searchResults = FetchRequest<Movie>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "filterKey == %@ && media_type == %@", "search", mediaFilter))
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
