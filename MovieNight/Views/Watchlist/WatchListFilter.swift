//
//  WatchlistFilter.swift
//  MovieNight
//
//  Created by Cory Popp on 10/3/22.
//

import SwiftUI

struct WatchListFilter: View {
    @FetchRequest var WatchlistMedia: FetchedResults<WatchlistMedia>
    
    var body: some View {
            ForEach(WatchlistMedia) { media in
                if media.media_type == "movie" {
                    NavigationLink {
                        WatchlistMediaView(media: media)
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(media.wrappedPosterPath)")) { image in
                                image.resizable()
                            } placeholder: {
                                Image("poster_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 75, height: 75)
                                    .overlay(Color.black.opacity(0.8))
                                
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipped()
                            
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
            
        _WatchlistMedia = FetchRequest<WatchlistMedia>(sortDescriptors: [], predicate: NSPredicate(format: "((media_type == %@) || (%@ == 'movie and tv')) && ((%@ == false) || (watched == %@)) && ((%@ == '') || (title CONTAINS[C] %@))", media_type, media_type, NSNumber(value: watchedSort), NSNumber(value: watched), searchQuery, searchQuery))
    }
    
}
