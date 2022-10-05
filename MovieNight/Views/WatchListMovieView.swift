    //
    //  WatchListMovieView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/30/22.
    //

import SwiftUI

struct WatchListMovieView: View {
    let watchlistItem: Watchlist
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        List {
            AddToWatchListButton(object: watchlistItem)
            WatchedButton(media: watchlistItem)
            
            Section("Movie Details") {
                Text(watchlistItem.wrappedTitle)
                Text("id: \(String(watchlistItem.id))")
                Text("media_type: \(watchlistItem.wrappedMediaType)")
                Text("original_title: \(watchlistItem.wrappedOriginalTitle)")
                Text("original_language: \(watchlistItem.wrappedOriginalLanguage)")
                Text("overview: \(watchlistItem.wrappedOverview)")
            }
            
            Section("Media Images") {
                Text("backdrop_path: \(watchlistItem.wrappedBackdropPath)")
                Text("poster_path: \(watchlistItem.wrappedPosterPath)")
            }
            
            Section("Voting") {
                Text("vote_average: \(String(watchlistItem.vote_average))")
                Text("vote_count: \(String(watchlistItem.vote_count))")
            }
        }
    }
}

    //struct WatchListMovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        WatchListMovieView()
    //    }
    //}
