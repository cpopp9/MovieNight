    //
    //  MovieView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import CoreData
import SwiftUI

struct MovieView: View {
    let movie: Movie
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        List {
            AddToWatchListButton(movie: movie)
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

    //struct MovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MovieView()
    //    }
    //}
