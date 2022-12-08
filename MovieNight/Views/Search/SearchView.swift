    //
    //  SearchView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct SearchView: View {
    @Environment(\.isSearching) private var isSearching: Bool

    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSearchObject == true")) var searchResults: FetchedResults<Media>
    
    @StateObject var searchVM = SearchViewModel()
    
    var body: some View {
        VStack {
            
            if searchResults.count > 0 {
                List {
                    SearchFilter(mediaFilter: "movie")
                    
                    SearchFilter(mediaFilter: "tv")
                }
                .listStyle(.automatic)
            } else {
                VStack {
                    Image(systemName: "text.magnifyingglass")
                        .font(.system(size: 45))
                        .foregroundColor(Color(.systemPink))
                        .padding(.vertical)
                    Text("Search for Movies and TV Shows")
                }
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for something")
        .onSubmit(of: .search) {
            Task {
                await searchVM.downloadSearchMedia(searchText: searchVM.searchText, context: moc)
            }
        }
        .onChange(of: searchVM.searchText) { value in
            if searchVM.searchText.isEmpty && !isSearching {
                searchVM.clearSearch(context: moc)
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
