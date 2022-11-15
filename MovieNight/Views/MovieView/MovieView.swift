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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            MovieTopDetails(media: media)
            
            AddToWatchListButton(media: media)
            
            MovieDetailView(media: media)
            
            CreditsView(media: media)
            
            SimilarMoviesView(media: media)
            
        }
        
        .background (
            
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)"), transaction: Transaction(animation: .spring())) { phase in
                switch phase {
                case .empty:
                    Color.black.opacity(0.9)
                        .scaledToFill()
                        .blur(radius: 50)
                        .overlay(Color.gray.opacity(0.1))
                        .ignoresSafeArea()
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 50)
                        .overlay(Color.gray.opacity(0.1))
                        .ignoresSafeArea()
                    
                case .failure(_):
                    Color.black.opacity(0.9)
                        .scaledToFill()
                        .blur(radius: 50)
                        .overlay(Color.gray.opacity(0.1))
                        .ignoresSafeArea()
                    
                @unknown default:
                    Color.black.opacity(0.9)
                        .scaledToFill()
                        .blur(radius: 50)
                        .overlay(Color.gray.opacity(0.1))
                        .ignoresSafeArea()
                }
            }
            
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
