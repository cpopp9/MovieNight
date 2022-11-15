    //
    //  MovieSearch.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/7/22.
    //

import SwiftUI

struct SearchFilter: View {
    
    @FetchRequest var searchResults: FetchedResults<Media>
    var mediaHeadline: String
    @State var showMore = false
    
    var body: some View {
        
        if searchResults.count > 0 {
            Section(mediaHeadline) {
                ForEach(searchResults.prefix(showMore ? 20 : 3)) { media in
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
                            
                            
                            
                                //                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(media.wrappedPosterPath)")) { image in
                                //                                image
                                //                                    .resizable()
                                //                                    .aspectRatio(contentMode: .fill)
                                //                                    .frame(width: 75, height: 75)
                                //                                    .clipped()
                                //
                                //                            } placeholder: {
                                //                                Image("poster_placeholder")
                                //                                    .resizable()
                                //                                    .aspectRatio(contentMode: .fill)
                                //                                    .frame(width: 75, height: 75)
                                //                                    .clipped()
                                //                            }
                            
                            VStack(alignment: .leading) {
                                Text(media.wrappedTitle)
                                    .font(.headline)
                                Text(media.wrappedReleaseDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .swipeActions() {
                        Button() {
                            media.watchlist.toggle()
                        } label: {
                            Image(systemName: media.watchlist ? "minus" : "plus")
                        }
                        .tint(media.watchlist ? .red : .green)
                        
                        Button() {
                            media.watched.toggle()
                        } label: {
                            Image(systemName: "eye")
                        }
                        .tint(media.watched ? .purple : .gray)
                        .disabled(!media.watchlist)
                    }
                }
                
                Button() {
                    showMore.toggle()
                } label: {
                    HStack {
                        Text(showMore ? "Show Less" : "Show More")
                        Spacer()
                        
                        if !showMore {
                            Text(String(searchResults.count))
                        }
                        
                        Image(systemName: showMore ? "minus" : "plus")
                    }
                }
            }
        }
    }
    
    init(mediaFilter: String) {
        _searchResults = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "isSearchObject == true && media_type == %@", mediaFilter))
        mediaHeadline = mediaFilter
    }
    
    func addMedia(at offsets: IndexSet) {
        for offset in offsets {
            let media = searchResults[offset]
            media.watchlist = true
        }
    }
}



    //struct MovieSearch_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SearchFilter()
    //    }
    //}
