//
//  DiscoverView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import SwiftUI

struct DiscoverView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "isDiscoverObject == true")) var discoverResults: FetchedResults<Media>
    
    @EnvironmentObject var dataController: DataController
    
    @State var pageCount = 1
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("New and upcoming releases:")
                    
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(discoverResults) { media in
                            DiscoverPoster(media: media)
                        }
                    }
                    .padding(.horizontal)
                }
                Image(systemName: "plus")
                    .padding()
                    .font(.system(size: 25))
                    .onTapGesture {
                        pageCount += 1
                        Task {
                            await dataController.loadDiscovery(filterKey: "discover", year: 2022, page: pageCount)
                        }
                    }
            }
            .navigationTitle("Discover")
        }
        .accentColor(.white)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
