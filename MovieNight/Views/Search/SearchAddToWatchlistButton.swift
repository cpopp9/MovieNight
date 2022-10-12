    //
    //  SearchAddToWatchlistButton.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/11/22.
    //

import CoreData
import SwiftUI

struct SearchAddToWatchlistButton: View {
    @Environment(\.managedObjectContext) var moc
    let media: SearchMedia
    @State var watchlistObject: WatchlistMedia?
    
    var body: some View {
        VStack {
            Button() {
                
                (watchlistObject != nil) ? deleteFromWatchlist() : saveToWatchlist()
                
            } label: {
                HStack {
                    Image(systemName: (watchlistObject != nil) ? "minus" : "plus")
                    Text((watchlistObject != nil) ? "Remove from Watchlist" : "Add to watchlist")
                }
                .frame(maxWidth: .infinity)
            }
            .tint((watchlistObject != nil) ? .red : .blue)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            
            Button() {
//                loadObject(contentId: Int(media.id))
                    watchlistObject?.watched.toggle()
                loadObject(contentId: Int(media.id))
            } label: {
                HStack {
                    if let watchlistObject = watchlistObject {
                        Image(systemName: watchlistObject.watched ? "checkmark.circle.fill" : "checkmark.circle")
                    } else {
                        Image(systemName: "checkmark.circle")
                    }
                    Text("Watched")
                }
                .frame(maxWidth: .infinity)
            }
            .tint((watchlistObject?.watched != nil) ? .gray : .green)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            .disabled(watchlistObject == nil)
        }
        .task {
            loadObject(contentId: Int(media.id))
        }
    }
    
    func loadObject(contentId: Int) {
        let fetchRequest: NSFetchRequest<WatchlistMedia> = WatchlistMedia.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", contentId)
        fetchRequest.fetchLimit = 1
        
        let context = moc
        
        watchlistObject = try? context.fetch(fetchRequest).first
    }
    
    func saveToWatchlist() {
        let newItem = WatchlistMedia(context: moc)
        newItem.title = media.title ?? "Unknown"
        newItem.id = Int32(media.id)
        newItem.backdrop_path = media.backdrop_path
        newItem.poster_path = media.poster_path
        newItem.media_type = media.media_type
        newItem.original_language = media.original_language
        newItem.original_title = media.original_title
        newItem.overview = media.overview
        newItem.vote_average = media.vote_average
        newItem.vote_count = media.vote_count
        newItem.watched = false
        
        try? moc.save()
        
        watchlistObject = newItem
    }
    
    func deleteFromWatchlist() {
        if let watchlistObject = watchlistObject {
            moc.delete(watchlistObject)
        }
        
        loadObject(contentId: Int(media.id))
        
        try? moc.save()
    }
    
    func markAsWatched() {
        if let watchlistObject = watchlistObject {
            watchlistObject.watched = true
            
                //            loadObject(contentId: Int(media.id))
        }
    }
    
    func markAsNotWatched() {
        if let watchlistObject = watchlistObject {
            watchlistObject.watched = false
        }
    }
}
    //
    //    struct SearchAddToWatchlistButton_Previews: PreviewProvider {
    //        static var previews: some View {
    //            AddToWatchListButton()
    //        }
    //    }

