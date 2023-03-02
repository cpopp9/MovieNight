    //
    //  MovieView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //
import SwiftUI

struct MovieView: View {
    @ObservedObject var media: Media
    @EnvironmentObject var mediaVM: MediaModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            MediaHeaderView(media: media)

            AddToMyMediaButton(media: media)

            MediaDetailView(media: media)

            CreditsView(media: media)

            SimilarMoviesView(media: media)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .background (
            Image(uiImage: media.wrappedPosterImage)
                .resizable()
                .blur(radius: 50)
                .overlay(Color.gray.opacity(0.1))
                .ignoresSafeArea()
            
        )
        
        .task {
            if media.tagline == nil {
                await mediaVM.downloadAdditionalMediaDetails(media: media)
            }
        }
    }
}

struct DiscoverMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(media: Media())
    }
}
