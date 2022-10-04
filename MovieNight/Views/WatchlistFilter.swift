//
//  WatchlistFilter.swift
//  MovieNight
//
//  Created by Cory Popp on 10/3/22.
//

import SwiftUI

struct WatchListFilter: View {
    @FetchRequest var WatchlistMedia: FetchedResults<Watchlist>
    
    var body: some View {
        List(WatchlistMedia, id: \.self) { media in
            NavigationLink {
                WatchListMovieView(watchlistItem: media)
            } label: {
                Text(media.title ?? "Unknown")
            }
        }
    }
    
    init(media_type: String, watchedSort: Bool, watched: Bool, searchQuery: String) {
            
        _WatchlistMedia = FetchRequest<Watchlist>(sortDescriptors: [], predicate: NSPredicate(format: "((media_type == %@) || (%@ == 'movie and tv')) && ((%@ == false) || (watched == %@)) && ((%@ == '') || (title CONTAINS[C] %@))", media_type, media_type, NSNumber(value: watchedSort), NSNumber(value: watched), searchQuery, searchQuery))
    }
    
}
