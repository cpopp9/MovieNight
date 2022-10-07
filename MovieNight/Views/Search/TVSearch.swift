//
//  TVSearch.swift
//  MovieNight
//
//  Created by Cory Popp on 10/7/22.
//

import SwiftUI

struct TVSearch: View {
    
    @State var searchText = ""
        //    @State var search = SearchResults(results: nil)
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "discovery == false")) var searchResults: FetchedResults<TV>
    
    @State var prefix = 3
    
    var body: some View {
        Section("TV Shows") {
            ForEach(searchResults) { tv in
//                if tv.media_type == "tv" {
                    NavigationLink {
//                        MovieView(movie: tv)
                        Text("tv show")
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(tv.wrappedPosterPath)")) { image in
                                image.resizable()
                            } placeholder: {
                                Image("poster_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .overlay(Color.black.opacity(0.8))
                                    
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            
                            VStack(alignment: .leading) {
                                Text(tv.wrappedTitle)
                                    .font(.headline)
                                Text(tv.wrappedReleaseDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }

struct TVSearch_Previews: PreviewProvider {
    static var previews: some View {
        TVSearch()
    }
}
