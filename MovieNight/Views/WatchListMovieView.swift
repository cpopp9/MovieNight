//
//  WatchListMovieView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/30/22.
//

import SwiftUI

struct WatchListMovieView: View {
    let movie: Watchlist
    @Environment(\.managedObjectContext) var moc
    @State var onList = false
    
    var body: some View {
        List {
            AddToWatchListButton(object: movie, movie: nil)
            Button() {
                onList.toggle()
                
                movie.watched = onList
                
                if moc.hasChanges {
                    try? moc.save()
                }
            } label: {
                HStack {
                    Image(systemName: onList ? "checkmark.circle.fill" : "checkmark.circle")
                    Text("Watched")
                }
            }
            Text("title: \(movie.title ?? "Unknown")")
            Text("id: \(String(movie.id))")
            Text("backdrop_path: \(movie.backdrop_path ?? "Unknown")")
            Text("poster_path: \(movie.poster_path ?? "Unknown")")
            Text("media_type: \(movie.media_type ?? "Unknown")")
            Text("original_title: \(movie.original_title ?? "Unknown")")
            Text("original_language: \(movie.original_language ?? "Unknown")")
            Text("overview: \(movie.overview ?? "Unknown")")
        }
    }
}

//struct WatchListMovieView_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchListMovieView()
//    }
//}
