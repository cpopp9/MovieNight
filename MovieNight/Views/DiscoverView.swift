    //
    //  DiscoverView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct DiscoverView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "discovery == true")) var discover: FetchedResults<Movie>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(discover) { searchResult in
                    NavigationLink {
                        MovieView(movie: searchResult)
                    } label: {
                        Text(searchResult.title ?? "Unknown")
                    }
                }
            }
            .navigationTitle("Discover")
            .task {
                await loadDiscovery()
            }
        }
    }
    
    func loadDiscovery() async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(SearchResults.self, from: data) {
                
                if let searchResults = decodedResponse.results {
                    
                    for item in searchResults {
                        let newItem = Movie(context: moc)
                        newItem.title = item.title ?? item.name ?? "Unknown"
                        newItem.id = Int32(item.id)
                        newItem.discovery = true
                        newItem.backdrop_path = item.backdrop_path
                        newItem.poster_path = item.poster_path
                        newItem.media_type = "movie"
                        newItem.original_language = item.original_language
                        newItem.original_title = item.original_title ?? item.original_name
                        newItem.overview = item.overview
                        newItem.watched = false
                        
//                        newItem.genre_ids = item.genre_ids
//                        newItem.vote_average = Double?(item.vote_average) ?? 0.0
//                        newItem.vote_count = Int(item.vote_count) ?? 0
                        
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
