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
                    
                    HStack {
                        Text(media.wrappedReleaseDate)
                            .foregroundColor(.secondary)
                        Text("·")
                        Text(media.wrappedStatus)
                            .foregroundColor(.secondary)
                    }
                    
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
                    .padding(.bottom)
                
                    // Additional Details
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Overview")
                            .font(.title2.bold())
                        Text("Sci-fi, Adventure, Action")
                            .font(.subheadline)
                        Text("\(media.runtime) minutes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom)
                    }
                    Spacer()
                    
                    Link(destination: URL(string: media.wrappedIMDBUrl)!) {
                        Image("imdb_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding(.trailing)
                    }
                }
                VStack(alignment: .leading) {
                    
                    if let tagline = media.tagline {
                        if tagline != "" {
                            Text(tagline)
                                .font(.title3.bold())
                                .padding(.bottom)
                        }
                    }
                    
                    Text(media.wrappedOverview)
                        .padding(.bottom)
                    
                }
                .padding(.top)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            RecommendedMoviesView(mediaID: String(media.id))
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
            await mediaDetails(mediaID: Int(media.id), media_type: media.wrappedMediaType)
            await mediaRecommendations(mediaID: Int(media.id), media_type: media.wrappedMediaType)
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
            fatalError("Invalid Data")
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
                        dataController.detectExistingObjects(item: item, filterKey: String(media.id))
                    }
                }
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
