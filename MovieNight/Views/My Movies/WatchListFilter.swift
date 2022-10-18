//
//  WatchlistFilter.swift
//  MovieNight
//
//  Created by Cory Popp on 10/3/22.
//

import SwiftUI

struct WatchListFilter: View {
    @FetchRequest var watchlistMedia: FetchedResults<Media>
    @Environment(\.managedObjectContext) var moc
    
    private var headerText: String
    
    var body: some View {
        Section(headerText) {
            ForEach(watchlistMedia) { media in
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
            .onDelete(perform: deleteMedia)
        }
    }
    
    init(media_type: String, watchedSort: Bool, watched: Bool, searchQuery: String) {
            
        _watchlistMedia = FetchRequest<Media>(sortDescriptors: [], predicate: NSPredicate(format: "watchlist == true && ((media_type == %@) || (%@ == 'movies and tv')) && ((%@ == false) || (watched == %@)) && ((%@ == '') || (title CONTAINS[C] %@))", media_type, media_type, NSNumber(value: watchedSort), NSNumber(value: watched), searchQuery, searchQuery))
        
        headerText = media_type
    }
    
    func deleteMedia(at offsets: IndexSet) {
        for offset in offsets {
            let media = watchlistMedia[offset]
            moc.delete(media)
        }
    }
    
}
