    //
    //  MovieView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //
import SwiftUI

struct MovieView: View {
    @ObservedObject var media: Media
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    
    let backupPoster = UIImage(systemName: "gravity")
    
    var body: some View {
        ScrollView {
            VStack {
                
                    // Backdrop Header
                
                ZStack {
                    if let backdropImage = media.backdropImage {
                        Image(uiImage: backdropImage)
                            .resizable()
                            .scaledToFit()
                            .overlay(Color.black.opacity(0.2))
                    }
                    
                    Image(systemName: "play.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                VStack {
                    
                        // Initial details
                    HStack {
                        if let posterImage = media.posterImage {
                            Image(uiImage: posterImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding(.trailing)
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(media.wrappedTitle)
                                    .font(.title.bold())
                                
                                Link(destination: URL(string: "https://chill.institute/#/search?keyword=\(media.wrappedChillTitle)")!) {
                                    Image(systemName: "link")
                                }
                            }
                            
                            Text(media.wrappedReleaseDate)
                                .foregroundColor(.secondary)
                            HStack {
                                MediaRatingView(rating: 4)
                                Text("(\(media.vote_count) ratings)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
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
        .task {
            await dataController.downloadBackdrop(media: media)
        }
    }
}

    //struct DiscoverMovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MovieView()
    //    }
    //}
