    //
    //  WatchlistView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import CoreData
import SwiftUI

struct WatchListView: View {
    @Environment(\.managedObjectContext) var moc
    
        // Filter data
    @State private var media_type = "movie and tv"
    @State private var searchText = ""
    @State private var watched = true
    @State private var watchedSort = false
    
    var body: some View {
        NavigationView {
            WatchListFilter(media_type: media_type, watchedSort: watchedSort, watched: watched, searchQuery: searchText)
            
            
                .navigationTitle("Watchlist")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu() {
                            
                            Button("All") {
                                watchedSort = false
                            }
                            
                            Button("Watched") {
                                watched = true
                                watchedSort = true
                            }
                            
                            Button("Unwatched") {
                                watched = false
                                watchedSort = true
                            }
                            
                        } label: {
                            Image(systemName: "eye")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu() {
                            
                            Button("Movies and TV") {
                                media_type = "movie and tv"
                            }
                            
                            Button("Movies") {
                                media_type = "movie"
                            }
                            
                            Button("TV") {
                                media_type = "tv"
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
        WatchListView()
    }
}
