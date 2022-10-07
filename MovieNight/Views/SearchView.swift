    //
    //  SearchView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
        //    @State var search = SearchResults(results: nil)
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "discovery == false")) var searchResults: FetchedResults<Movie>
    
    
    var body: some View {
        NavigationView {
            List {
                Section("Movies") {
                    ForEach(searchResults) { movie in
                        if movie.media_type == "movie" {
                            NavigationLink {
                                MovieView(movie: movie)
                            } label: {
                                
                                HStack {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.wrappedPosterPath)")) { image in
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
                                        Text(movie.wrappedTitle)
                                            .font(.headline)
                                        Text(movie.wrappedReleaseDate)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section("TV Shows") {
                    ForEach(searchResults) { tv in
                        if tv.media_type == "tv" {
                            NavigationLink {
                                MovieView(movie: tv)
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
                
                Section("Actors") {
                    ForEach(searchResults) { person in
                        if person.media_type == "person" {
                            NavigationLink {
                                ActorView(person: person)
                            } label: {
                                HStack {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(person.wrappedPosterPath)")) { image in
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
                                        Text(person.wrappedTitle)
                                            .font(.headline)
                                        Text(person.wrappedReleaseDate)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            .navigationTitle("Search")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a movie")
            .onChange(of: searchText) { newValue in
                Task {
                    await multiSearch()
                }
            }
        }
    }
    
    func multiSearch() async {
        
        for objects in searchResults {
            moc.delete(objects)
        }
        
        var encoded: String {
            
            if let encodedText = searchText.stringByAddingPercentEncodingForRFC3986() {
                return encodedText
            } else {
                return "Failed"
            }
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/multi?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&query=\(encoded)&page=1&include_adult=false") else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(SearchResults.self, from: data) {
                    //                search.results = decodedResponse.results
                
                if let searchResults = decodedResponse.results {
                    
                    for item in searchResults {
                        searchItem(item: item)
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func searchItem(item: SearchResult) {
        let newItem = Movie(context: moc)
        newItem.title = item.title ?? item.name ?? "Unknown"
        newItem.id = Int32(item.id)
        newItem.backdrop_path = item.backdrop_path
        newItem.discovery = false
        newItem.poster_path = item.poster_path ?? item.profile_path
        newItem.media_type = item.media_type
        newItem.original_language = item.original_language
        newItem.original_title = item.original_title ?? item.original_name
        newItem.overview = item.overview
        newItem.release_date = item.release_date
        
            //        newItem.genre_ids = item.genre_ids
        
        if let vote_average = item.vote_average {
            newItem.vote_average = vote_average
        }
        
        if let vote_count = item.vote_count {
            newItem.vote_count = Int16(vote_count)
        }
    }
    
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
