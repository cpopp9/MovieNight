    //
    //  SearchView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSearchMedia == true")) var searchResults: FetchedResults<Movie>
    @Environment(\.isSearching) private var isSearching: Bool
    
    
    @State var prefix = 3
    
    var body: some View {
        NavigationView {
            List {
                SearchFilter()
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a movie")
            .onSubmit(of: .search) {
                Task {
                    await multiSearch()
                }
            }
            .onChange(of: searchText) { value in
                if searchText.isEmpty && !isSearching {
                    clearSearch()
                    try? moc.save()
                }
            }
        }
    }
    
    func clearSearch() {
        for media in searchResults {
            if media.watchlist {
                media.isSearchMedia = false
            } else {
                moc.delete(media)
            }
        }
    }
    
    func multiSearch() async {
        
        clearSearch()
        
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
        newItem.poster_path = item.poster_path ?? item.profile_path
        newItem.media_type = item.media_type
        newItem.original_language = item.original_language
        newItem.original_title = item.original_title ?? item.original_name
        newItem.overview = item.overview
        newItem.popularity = item.popularity ?? 0.0
        newItem.isSearchMedia = true
        newItem.isDiscoverMedia = false
        
        if let date = item.release_date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsed = formatter.date(from: date) {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: parsed)
                newItem.release_date = "\(year)"
            }
        }
        
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
