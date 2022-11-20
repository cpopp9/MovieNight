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

            MovieDetailView(media: media)

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
                await downloadAdditionalMediaDetails(media: media)
            }
        }
    }
    
    func downloadAdditionalMediaDetails(media: Media) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaDetails.self, from: data) {
                
                media.imdb_id = decodedResponse.imdb_id
                media.runtime = Int16(decodedResponse.runtime ?? 0)
                media.tagline = decodedResponse.tagline
                media.status = decodedResponse.status
                media.number_of_seasons = Int16(decodedResponse.number_of_seasons ?? 0)
                
                if let genres = decodedResponse.genres {
                    var genString = [String]()
                    
                    for genre in genres {
                        genString.append(genre.name)
                    }
                    
                    media.genres = genString.joined(separator: ", ")
                }
                
                
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
    }
    
}

struct DiscoverMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(media: Media())
    }
}
