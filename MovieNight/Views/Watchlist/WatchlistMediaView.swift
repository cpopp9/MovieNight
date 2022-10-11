//
//  WatchlistMediaView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/11/22.
//

    import CoreData
    import SwiftUI

    struct WatchlistMediaView: View {
        @ObservedObject var media: WatchlistMedia
        @Environment(\.managedObjectContext) var moc
        
        var body: some View {
            ScrollView {
                ZStack {
                    VStack {
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
                            
                            RemoveFromWatchlistButton(watchlistObject: media)
                            
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
                        .padding(.horizontal)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .ignoresSafeArea()
            
        }
    }

        //struct WatchlistMediaView_Previews: PreviewProvider {
        //    static var previews: some View {
        //        MovieView()
        //    }
        //}


