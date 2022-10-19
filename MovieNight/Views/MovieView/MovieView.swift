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
                
                VStack {
                    if let posterImage = media.posterImage {
                        Image(uiImage: posterImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.trailing)
                    }
                        // Initial details
                    VStack(alignment: .center) {
                        HStack {
                            
                            Link(destination: URL(string: "https://chill.institute/#/search?keyword=\(media.wrappedChillTitle)")!) {
                                Text(media.wrappedTitle)
                                    .font(.title.bold())
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
        
        .background(
            Image(uiImage: media.posterImage!)
                .resizable()
                .scaledToFill()
                .blur(radius: 50)
                .ignoresSafeArea()
        )
            //        .ignoresSafeArea()
    }
}

    //struct DiscoverMovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MovieView()
    //    }
    //}
