//
//  WatchlistFilter.swift
//  MovieNight
//
//  Created by Cory Popp on 10/3/22.
//

import SwiftUI

struct WatchListFilter: View {
    @FetchRequest var fetchRequest: FetchedResults<Watchlist>
    
    var body: some View {
        List(fetchRequest, id: \.self) { media in
            NavigationLink {
                WatchListMovieView(movie: media)
            } label: {
                Text(media.title ?? "Unknown")
            }
        }
    }
    
//    init(filter: String, noWatchedSort: Bool, watched: Bool, type: String) {
//
//        _fetchRequest = FetchRequest<Watchlist>(sortDescriptors: [], predicate: NSPredicate(format: "((type == %@) || (%@ == '')) && ((%@ == true) || (watched == %@)) && ((%@ == '') || (title CONTAINS[C] %@))", type, type, NSNumber(value: noWatchedSort), NSNumber(value: watched), filter, filter))
//    }
    
    init(media_type: String, watchedSort: Bool, watched: Bool, searchQuery: String) {
            
        _fetchRequest = FetchRequest<Watchlist>(sortDescriptors: [], predicate: NSPredicate(format: "((media_type == %@) || (%@ == 'movie and tv')) && ((%@ == false) || (watched == %@)) && ((%@ == '') || (title CONTAINS[C] %@))", media_type, media_type, NSNumber(value: watchedSort), NSNumber(value: watched), searchQuery, searchQuery))
    }
    
}
