    //
    //  SearchView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct SearchView: View {
//    @Environment(\.managedObjectContext) var moc
    @Environment(\.isSearching) private var isSearching: Bool
    
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "filterKey == %@", "search")) var searchResults: FetchedResults<Media>
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                if searchResults.count > 0 {
                    List {
                        Section("Movies") {
                            SearchFilter(mediaFilter: "movie")
                        }
                        
                        Section("TV") {
                            SearchFilter(mediaFilter: "tv")
                        }
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
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for something")
            .onSubmit(of: .search) {
                Task {
                    await dataController.multiSearch(searchText: searchText)
                }
            }
            .onChange(of: searchText) { value in
                if searchText.isEmpty && !isSearching {
                    dataController.clearMedia(filterKey: "search")
                }
            }
        }
        .accentColor(.white)
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
