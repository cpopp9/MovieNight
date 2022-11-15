//
//  WatchlistFilter.swift
//  MovieNight
//
//  Created by Cory Popp on 10/3/22.
//

import SwiftUI

struct WatchListFilter: View {
    @FetchRequest var watchlistMedia: FetchedResults<Media>
    @EnvironmentObject var dataController: DataController
    
    private var headerText: String
    
    var body: some View {
        Section(headerText) {
            ForEach(watchlistMedia) { media in
                    NavigationLink {
                        MovieView(media: media)
                    } label: {
                        HStack {
                            
                            
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)"), transaction: Transaction(animation: .spring())) { phase in
                                switch phase {
                                case .empty:
                                    Color.black.opacity(0.1)
                                    
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    
                                case .failure(_):
                                    Color.black
                                        .scaledToFit()
                                    
                                @unknown default:
                                    Image(systemName: "exclamationmark.icloud")
                                }
                            }
                            
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
            dataController.container.viewContext.delete(media)
        }
    }
}

struct WatchListFilter_Previews: PreviewProvider {
    static var previews: some View {
        WatchListFilter(media_type: "movie", watchedSort: true, watched: true, searchQuery: "")
    }
}
