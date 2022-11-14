    //
    //  WatchlistView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import CoreData
import SwiftUI

struct MyMoviesView: View {
    @Environment(\.managedObjectContext) var moc
    
        // Filter data
    @State private var media_type = "movies and tv"
    @State private var searchText = ""
    @State private var watched = true
    @State private var watchedSort = false
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "watchlist == true")) var watchlistResults: FetchedResults<Media>
    
    var body: some View {
        NavigationView {
            VStack {
                if watchlistResults.count > 0 {
                    List {
                        WatchListFilter(media_type: media_type, watchedSort: watchedSort, watched: watched, searchQuery: searchText)
                    }
                    
                } else {
                    VStack {
                        Image(systemName: "video")
                            .font(.system(size: 45))
                            .foregroundColor(Color(.systemPink))
                            .padding(.vertical)
                        Text("Add Movies and TV shows to start building a watchlist")
                    }
                }
            }
            
            .navigationTitle("My Movies")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu() {
                        
                        Menu() {
                            Button {
                                watched = true
                                watchedSort = true
                            } label: {
                                Text("Watched")
                            }
                            Button {
                                watched = false
                                watchedSort = true
                            } label: {
                                Text("Unwatched")
                            }
                            
                            Button {
                                watchedSort = false
                            } label: {
                                Text("All")
                            }
                            
                        } label: {
                            HStack {
                                Text("Watch Status")
                                Image(systemName: "eye")
                            }
                        }
                        
                        Menu() {
                            
                            Button {
                                media_type = "movie"
                            } label: {
                                Text("Show Movies")
                            }
                            
                            Button {
                                media_type = "tv"
                            } label: {
                                Text("Show TV")
                            }
                            
                            Button {
                                media_type = "movies and tv"
                            } label: {
                                Text("Show All")
                            }

                            
                        } label: {
                            HStack {
                                HStack {
                                    Text("Media Type")
                                    Image(systemName: "tv")
                                }
                            }
                        }
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}


struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        MyMoviesView()
    }
}
