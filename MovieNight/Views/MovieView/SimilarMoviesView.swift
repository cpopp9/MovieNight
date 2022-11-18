    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI
import CoreData

struct SimilarMoviesView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var media: Media
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if !media.similarArray.isEmpty {
                
                Text("You might also like \(media.similarArray.count)")
                    .font(.title.bold())
                    .padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(media.similarArray) { media in
                            SimilarPostersView(media: media)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .task {
            if media.similarArray.isEmpty {
                await downloadSimilarMedia(media: media)
            }
        }
    }
    
    
    func downloadSimilarMedia(media: Media) async {
        
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(media.wrappedMediaType)/\(media.id)/recommendations?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let similarResults = decodedResponse.results {
                    
                    for item in similarResults {
                        if item.poster_path == nil { continue }
                        
                        media.addToSimilar(dataController.CreateMediaObject(item: item, context: moc))
                    }
                    
                }
            }
            
        } catch let error {
            print("Invalid Data \(error)")
        }
        dataController.saveMedia(context: moc)
    }
    
}

struct SimilarMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        SimilarMoviesView(media: Media())
    }
}

