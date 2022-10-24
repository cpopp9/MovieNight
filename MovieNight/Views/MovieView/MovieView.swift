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
            
            CreditsView(credits: credits)
            
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
            await mediaDetails(mediaID: Int(media.id), media_type: media.wrappedMediaType)
            await mediaRecommendations(mediaID: Int(media.id), media_type: media.wrappedMediaType)
            await getCredits(mediaID: Int(media.id), media_type: media.wrappedMediaType)
        }
    }
    
    func mediaDetails(mediaID: Int, media_type: String) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media_type)/\(mediaID)?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaDetails.self, from: data) {
                
                media.imdb_id = decodedResponse.imdb_id
                media.runtime = Int16(decodedResponse.runtime ?? 0)
                media.revenue = Int64(decodedResponse.revenue ?? 0)
                media.tagline = decodedResponse.tagline
                media.status = decodedResponse.status
                
            }
        } catch {
            print("Invalid Data")
        }
    }
    
    func mediaRecommendations(mediaID: Int, media_type: String) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media_type)/\(mediaID)/recommendations?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        dataController.detectExistingObjects(item: item, filterKey: String(media.id), isDiscoverObject: nil, isSearchObject: nil)
                    }
                }
            }
            
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    func getCredits(mediaID: Int, media_type: String) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media_type)/\(mediaID)/credits?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Credits.self, from: data) {
                
                credits = decodedResponse
                
                
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
}

struct DiscoverMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(media: Media())
    }
}
