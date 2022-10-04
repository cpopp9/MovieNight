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
                ForEach(searchResults) { result in
                    NavigationLink {
                        MovieView(movie: result)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.wrappedTitle)
                                .font(.headline)
                            Text(result.wrappedMediaType)
                                .font(.caption)
                                .foregroundColor(.secondary)
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
        newItem.poster_path = item.poster_path
        newItem.media_type = item.media_type
        newItem.original_language = item.original_language
        newItem.original_title = item.original_title ?? item.original_name
        newItem.overview = item.overview
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