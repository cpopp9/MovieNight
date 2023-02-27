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
                            Task {
                                await discoverVM.downloadDiscoveryMedia(context: moc)
                                discoverVM.pageCount += 1
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
//                    Menu() {
//                        Button() {
//                            discoverVM.selectedMediaType = "movie"
//                            discoverVM.deleteObjects(filter: .discover, context: moc)
//                            discoverVM.pageCount = 1
//                        } label: {
//                            Text("Movies")
//                        }
//                        Button() {
//                            discoverVM.selectedMediaType = "tv"
//                            discoverVM.deleteObjects(filter: .discover, context: moc)
//                            discoverVM.pageCount = 1
//                        } label: {
//                            Text("TV Shows")
//                        }
//                    } label: {
//                        Text("Media Type")
//                    }
                    
//                    Menu() {
                        Button() {
                            discoverVM.selectedRange = .current
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("Current")
                        }
                        Button() {
                            discoverVM.selectedRange = .twentyTens
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("2010's")
                        }
                        Button() {
                            discoverVM.selectedRange = .twoThousands
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("2000's")
                        }
                        Button() {
                            discoverVM.selectedRange = .nineties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("90's")
                        }
                        Button() {
                            discoverVM.selectedRange = .eighties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("80's")
                        }
                        Button() {
                            discoverVM.selectedRange = .seventies
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("70's")
                        }
                        Button() {
                            discoverVM.selectedRange = .sixties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("60's")
                        }
                        Button() {
                            discoverVM.selectedRange = .fifties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("50's")
                        }
//                    } label: {
//                        Text("Decade")
//                    }
                    
                } label: {
                    Image(systemName: "calendar")
                }
            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
