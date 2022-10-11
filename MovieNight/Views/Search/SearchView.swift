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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)]) var searchResults: FetchedResults<SearchMedia>
    
    @State var prefix = 3
    
    
    var body: some View {
        NavigationView {
            List {
                MovieSearch()
//                TVSearch()
                
//                Section("Actors") {
//                    ForEach(searchResults) { person in
//                        if person.media_type == "person" {
//                            NavigationLink {
//                                ActorView(person: person)
//                            } label: {
//                                HStack {
//                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(person.wrappedPosterPath)")) { image in
//                                        image.resizable()
//                                    } placeholder: {
//                                        Image("poster_placeholder")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fill)
//                                            .frame(width: 100, height: 100)
//                                            .overlay(Color.black.opacity(0.8))
//
//                                    }
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 100, height: 100)
//                                    .clipped()
//
//                                    VStack(alignment: .leading) {
//                                        Text(person.wrappedTitle)
//                                            .font(.headline)
//                                        Text(person.wrappedReleaseDate)
//                                            .font(.caption)
//                                            .foregroundColor(.secondary)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
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
        
        moc.rollback()
        
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
                        
                        if item.media_type == "movie" {
                            searchItem(item: item)
                        } else if item.media_type == "tv" {
//                            tvSearch(item: item)
                        }
                    }
                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func searchItem(item: SearchResult) {
        let newItem = SearchMedia(context: moc)
        newItem.title = item.title ?? item.name ?? "Unknown"
        newItem.id = Int32(item.id)
        newItem.backdrop_path = item.backdrop_path
        newItem.poster_path = item.poster_path ?? item.profile_path
        newItem.media_type = item.media_type
        newItem.original_language = item.original_language
        newItem.original_title = item.original_title ?? item.original_name
        newItem.overview = item.overview
        newItem.popularity = item.popularity ?? 0.0
        
        if let date = item.release_date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsed = formatter.date(from: date) {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: parsed)
                newItem.release_date = "\(year)"
            }
        }
        
            //        newItem.genre_ids = item.genre_ids
        
        if let vote_average = item.vote_average {
            newItem.vote_average = vote_average
        }
        
        if let vote_count = item.vote_count {
            newItem.vote_count = Int16(vote_count)
        }
    }
    
//    func tvSearch (item: SearchResult) {
//        let newItem = TV(context: moc)
//        newItem.title = item.name ?? "Unknown"
//        newItem.id = Int32(item.id)
//        newItem.backdrop_path = item.backdrop_path
//        newItem.discovery = false
//        newItem.poster_path = item.poster_path
//        newItem.media_type = item.media_type
//        newItem.original_language = item.original_language
//        newItem.original_title = item.original_title ?? item.original_name
//        newItem.overview = item.overview
//        newItem.release_date = item.release_date
//        newItem.popularity = item.popularity ?? 0.0
//        
//            //        newItem.genre_ids = item.genre_ids
//        
//        if let vote_average = item.vote_average {
//            newItem.vote_average = vote_average
//        }
//        
//        if let vote_count = item.vote_count {
//            newItem.vote_count = Int16(vote_count)
//        }
//    }
    
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
