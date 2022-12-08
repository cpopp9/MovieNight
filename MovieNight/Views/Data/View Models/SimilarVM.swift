//
//  SimilarVM.swift
//  MovieNight
//
//  Created by Cory Popp on 12/8/22.
//

import Foundation
import CoreData

@MainActor class SimilarViewModel: MediaModel {
    func downloadSimilarMedia(media: Media, context: NSManagedObjectContext) async {
        
        
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
                        
                        media.addToSimilar(createMediaObject(item: item, context: context))
                    }
                    
                }
            }
            
        } catch let error {
            print("Invalid Data \(error)")
        }
        saveMedia(context: context)
    }
}
