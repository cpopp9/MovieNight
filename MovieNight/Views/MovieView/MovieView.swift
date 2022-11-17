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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            MovieTopDetails(media: media)
            
            ButtonView(media: media)
            
//            AddToWatchListButton(media: media)
            
            MovieDetailView(media: media)
            
//            CreditsView(media: media)
            
            SimilarMoviesView(media: media)
            
        }
        
        .background (
            
            Image(uiImage: media.wrappedPosterImage)
                .resizable()
                .scaledToFill()
                .blur(radius: 50)
                .overlay(Color.gray.opacity(0.1))
                .ignoresSafeArea()
            
        )
        
        .task {
            if media.tagline == nil {
                await dataController.downloadAdditionalMediaDetails(media: media)
            }
        }
    }
}

struct DiscoverMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(media: Media())
    }
}
