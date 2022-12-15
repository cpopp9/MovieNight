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
                            .opacity(0)
                            .onAppear {
                                discoverVM.pageCount += 1
                                Task {
                                    await discoverVM.downloadDiscoveryMedia(year: 1990, page: discoverVM.pageCount, context: moc)
                                }
                            }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Discover")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu() {
                        Menu() {
                            Button() {
                                
                            } label: {
                                Text("Movies")
                            }
                            Button() {
                                
                            } label: {
                                Text("TV Shows")
                            }
                        } label: {
                            Text("Media Type")
                        }
                        
                        Menu() {
                            Button() {
                                discoverVM.selectedRange = .current
                                discoverVM.deleteObjects(filter: .discover, context: moc)
                            } label: {
                                Text("Current")
                            }
                            Button() {
                                discoverVM.selectedRange = .nineties
                                discoverVM.deleteObjects(filter: .discover, context: moc)
                            } label: {
                                Text("90's")
                            }
                            Button() {
                                discoverVM.selectedRange = .eighties
                                discoverVM.deleteObjects(filter: .discover, context: moc)
                            } label: {
                                Text("80's")
                            }
                        } label: {
                            Text("Decade")
                        }
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
            .task {
                if discoverResults.isEmpty {
                    await discoverVM.downloadDiscoveryMedia(year: 1990, page: 1, context: moc)
                }
            }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
