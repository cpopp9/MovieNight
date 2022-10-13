//
//  WatchlistFilter.swift
//  MovieNight
//
//  Created by Cory Popp on 10/3/22.
//

import SwiftUI

struct WatchListFilter: View {
    @FetchRequest var WatchlistMedia: FetchedResults<Movie>
    
    var body: some View {
            ForEach(WatchlistMedia) { media in
                if media.media_type == "movie" {
                    NavigationLink {
                        MovieView(media: media)
                    } label: {
                        HStack {
                            if let posterImage = media.posterImage {
                                Image(uiImage: posterImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 75, height: 75)
                                    .clipped()
                            }
                            
                            VStack(alignment: .leading) {
                                Text(media.wrappedTitle)
                                    .font(.headline)
                                Text(media.wrappedReleaseDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    
    init(media_type: String, watchedSort: Bool, watched: Bool, searchQuery: String) {
            
        _WatchlistMedia = FetchRequest<Movie>(sortDescriptors: [], predicate: NSPredicate(format: "watchlist == true && ((media_type == %@) || (%@ == 'movie and tv')) && ((%@ == false) || (watched == %@)) && ((%@ == '') || (title CONTAINS[C] %@))", media_type, media_type, NSNumber(value: watchedSort), NSNumber(value: watched), searchQuery, searchQuery))
    }
    
}
