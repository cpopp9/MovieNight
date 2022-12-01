    //
    //  SearchView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct SearchView: View {
    @Environment(\.isSearching) private var isSearching: Bool
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSearchObject == true")) var searchResults: FetchedResults<Media>
    
    @State var searchText = ""
    
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
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for something")
        .onSubmit(of: .search) {
            Task {
                await downloadSearchMedia(searchText: searchText)
            }
        }
        .onChange(of: searchText) { value in
            if searchText.isEmpty && !isSearching {
                dataController.clearSearch()
            }
        }
    }
    
    func downloadSearchMedia(searchText: String) async {
        
        dataController.clearSearch()
        
        var encoded: String {
            if let encodedText = searchText.stringByAddingPercentEncodingForRFC3986() {
                return encodedText
            } else {
                return "Failed"
            }
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/multi?api_key=\(dataController.API_KEY)&language=en-US&query=\(encoded)&page=1&include_adult=false") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let searchResults = decodedResponse.results {
                    
                    for item in searchResults {
                        dataController.CreateMediaObject(item: item, context: moc).isSearchObject = true
                    }
                }
            }
        } catch let error {
            fatalError("Invalid Data \(error)")
        }
        dataController.saveMedia(context: moc)
    }
    
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
