//
//  DiscoverView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import SwiftUI

struct DiscoverView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeAdded, order: .forward)], predicate: NSPredicate(format: "isDiscoverObject == true")) var discoverResults: FetchedResults<Media>
    
    @StateObject var discoverVM = DiscoverViewModel()
    
    @Environment(\.managedObjectContext) var moc
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("New and upcoming releases:")
                    
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(discoverResults) { media in
                            DiscoverPoster(media: media)
                        }
                        Image(systemName: "plus")
                            .padding()
                            .opacity(0)
                            .onAppear {
                                discoverVM.currentPage += 1
                                Task {
                                    await discoverVM.downloadDiscoveryMedia(year: 2022, page: discoverVM.currentPage, context: moc)
                                }
                            }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Discover")
            .task {
                if discoverResults.isEmpty {
                    await discoverVM.downloadDiscoveryMedia(year: 2022, page: 1, context: moc)
                }
            }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
