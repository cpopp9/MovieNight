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
    @State var onList = false
    
    var body: some View {
        List {
            AddToWatchListButton(movie: movie)
            
            Section("Movie Details") {
                Text("title: \(movie.wrappedTitle)")
                Text("id: \(String(movie.id))")
                Text("media_type: \(movie.wrappedMediaType)")
                Text("original_title: \(movie.wrappedOriginalTitle)")
                Text("original_language: \(movie.wrappedOriginalLanguage)")
                Text("overview: \(movie.wrappedOverview)")
                Text("Release Date: \(movie.wrappedReleaseDate)")
            }
            
            Section("Media Images") {
                Text("backdrop_path: \(movie.wrappedBackdropPath)")
                Text("poster_path: \(movie.wrappedPosterPath)")
            }
            
            Section("Voting") {
                Text("vote_average: \(String(movie.vote_average))")
                Text("vote_count: \(String(movie.vote_count))")
            }
        }
        .navigationTitle(movie.wrappedTitle)
    }
}

    //struct MovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MovieView()
    //    }
    //}
