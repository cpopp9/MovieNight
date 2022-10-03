//
//  AddToWatchListButton.swift
//  MovieNight
//
//  Created by Cory Popp on 9/30/22.
//

import CoreData
import SwiftUI

struct AddToWatchListButton: View {
    @Environment(\.managedObjectContext) var moc
    @State var object: Watchlist?
    var movie: Movie?
    
    var onList: Bool {
        if let object = object {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        
        VStack {
            Button() {
                onList ? deleteFromWatchlist() : saveToWatchlist()
                
                if let movie = movie {
                    loadObject(contentId: Int(movie.id))
                }
                
                if let object = object {
                    loadObject(contentId: Int(object.id))
                }
            
            } label: {
                HStack {
                    Image(systemName: onList ? "minus" : "plus")
                    Text(onList ? "Remove from Watchlist" : "Add to watchlist")
                }
                .frame(maxWidth: .infinity)
            }
            .tint(onList ? .red : .blue)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            .padding()
        }
        .task {
            if let movie = movie {
                loadObject(contentId: Int(movie.id))
            }
            
            if let object = object {
                loadObject(contentId: Int(object.id))
            }
        }
    }
    
    func loadObject(contentId: Int) {
        let fetchRequest: NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", contentId)
        fetchRequest.fetchLimit = 1
        
        let context = moc
        
        object = try? context.fetch(fetchRequest).first
    }
    
    func saveToWatchlist() {
        if let movie = movie {
            
            let newItem = Watchlist(context: moc)
            newItem.title = movie.title ?? "Unknown"
            newItem.id = Int32(movie.id)
            newItem.backdrop_path = movie.backdrop_path
            newItem.poster_path = movie.poster_path
            newItem.media_type = movie.media_type
            newItem.original_language = movie.original_language
            newItem.original_title = movie.original_title
            newItem.overview = movie.overview
            newItem.watched = movie.watched
//            newItem.watched = false
            
            try? moc.save()
        }
    }
    
    func deleteFromWatchlist() {
        if let object = object {
            moc.delete(object)
        }
        
        try? moc.save()
    }
    
    
    
}

//struct AddToWatchListButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToWatchListButton()
//    }
//}
