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
        ScrollView {
            ZStack {
                VStack {
                    ZStack {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(watchlistItem.wrappedBackdropPath)")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .scaledToFit()
                        .overlay(Color.black.opacity(0.2))
                        
                        Image(systemName: "play.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    
                    VStack {
                        HStack {
                            
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(watchlistItem.wrappedPosterPath)")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Text(watchlistItem.wrappedTitle)
                                    .font(.title.bold())
                                Text("2013")
                                Text("⭐️⭐️⭐️⭐️⭐️")
                                
                            }
                            Spacer()
                        }
                        
                        AddToWatchListButton(object: watchlistItem)
                        
                        VStack(alignment: .leading) {
                            Text("Overview")
                                .font(.title2.bold())
                            Text("Sci-fi, Adventure, Action")
                                .font(.subheadline)
                                .padding(.bottom)
                            Text(watchlistItem.wrappedOverview)
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea()
        
        
            //        List {
            //            AddToWatchListButton(movie: movie)
            //
            //            Section("Movie Details") {
            //                Text("title: \(movie.wrappedTitle)")
            //                Text("id: \(String(movie.id))")
            //                Text("media_type: \(movie.wrappedMediaType)")
            //                Text("original_title: \(movie.wrappedOriginalTitle)")
            //                Text("original_language: \(movie.wrappedOriginalLanguage)")
            //                Text("overview: \(movie.wrappedOverview)")
            //                Text("Release Date: \(movie.wrappedReleaseDate)")
            //            }
            //
            //            Section("Media Images") {
            //                Text("backdrop_path: \(movie.wrappedBackdropPath)")
            //                Text("poster_path: \(movie.wrappedPosterPath)")
            //            }
            //
            //            Section("Voting") {
            //                Text("vote_average: \(String(movie.vote_average))")
            //                Text("vote_count: \(String(movie.vote_count))")
            //            }
            //        }
            //        .navigationTitle(movie.wrappedTitle)
    }
}

    //struct WatchListMovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        WatchListMovieView()
    //    }
    //}
