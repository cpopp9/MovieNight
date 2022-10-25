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
    
    @State var credits = Credits(cast: [])
    
    var body: some View {
        ScrollView {
            
            MovieTopDetails(media: media)
            
            AddToWatchListButton(media: media)
            
            MovieDetailView(media: media)
            
            CreditsView()
            
            SimilarMoviesView(mediaID: String(media.id))
            
        }
        .background(
            Image(uiImage: media.wrappedPosterImage)
                .resizable()
                .scaledToFill()
                .blur(radius: 50)
                .ignoresSafeArea()
        )
        .task {
            await dataController.additionalMediaDetails(media: media)
            await dataController.getCredits(media: media)
            await dataController.mediaRecommendations(media: media)
        }
    }
}

struct DiscoverMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(media: Media())
    }
}
