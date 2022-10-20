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
    @State var mediaDetails = MediaDetails(genres: [], imdb_id: "", revenue: 0, runtime: 0, status: "", tagline: "")
    
    var body: some View {
        ScrollView {
                
                VStack {
                    Image(uiImage: media.wrappedPosterImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.trailing)
                        // Initial details
                    VStack {
                        
                            Text(media.wrappedTitle)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                        
                        
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
                        ForEach(mediaDetails.genres, id:\.name) { genre in
                            Text(genre.name)
                        }
                        Text(mediaDetails.status)
                        Text(mediaDetails.tagline)
                        Text(String(mediaDetails.revenue))
                        Text(String(mediaDetails.runtime))
                        Text(mediaDetails.imdb_id)
                    }
                    .padding(.top)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                Spacer()
        }
        
        .background(
            Image(uiImage: media.wrappedPosterImage)
                .resizable()
                .scaledToFill()
                .blur(radius: 50)
                .ignoresSafeArea()
        )
        .task {
            await mediaDetails(mediaID: Int(media.id))
        }
    }
    
    func mediaDetails(mediaID: Int) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(mediaID)?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaDetails.self, from: data) {
                
                mediaDetails = decodedResponse
                
//                if let searchResults = decodedResponse.results {
//
//                    for item in searchResults {
//                        detectExistingObjects(item: item, filterKey: "search")
//                    }
//                }
            }
        } catch {
            fatalError("Invalid Data")
        }
    }
    
    
}

    //struct DiscoverMovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MovieView()
    //    }
    //}
