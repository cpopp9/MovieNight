    //
    //  MovieView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //
import SwiftUI

struct MovieView: View {
    @ObservedObject var media: Movie
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        ScrollView {
                VStack {
                    
                    // Backdrop Header
                    
                    ZStack {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(media.wrappedBackdropPath)")) { image in
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
                        
                        // Initial details
                        HStack {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(media.wrappedPosterPath)")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Text(media.wrappedTitle)
                                    .font(.title.bold())
                                Text(media.wrappedReleaseDate)
                                    .foregroundColor(.secondary)
                                Text("⭐️⭐️⭐️⭐️⭐️")
                            }
                            Spacer()
                        }
                        
                        // Save to watchlist button
                        AddToWatchListButton(media: media)
                        
                        // Additional Details
                        VStack(alignment: .leading) {
                            Text("Overview")
                                .font(.title2.bold())
                            Text("Sci-fi, Adventure, Action")
                                .font(.subheadline)
                                .padding(.bottom)
                            Text(media.wrappedOverview)
                        }
                        .padding(.top)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    Spacer()
                }
        }
        .ignoresSafeArea()
    }
}

    //struct DiscoverMovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MovieView()
    //    }
    //}
