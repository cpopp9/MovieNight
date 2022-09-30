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
    var movie: Movie
    
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
            
                loadObject(contentId: Int(movie.id))
            } label: {
                Text(onList ? "Remove from Watchlist" : "Add to watchlist")
            }
        }
        
//        if let onList = object {
//            Text("On watchlist")
//        } else {
//            Text("Not on watchlist")
//        }
    }
    
    func loadObject(contentId: Int) {
        let fetchRequest: NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", contentId)
        fetchRequest.fetchLimit = 1
        
        let context = moc
        
        object = try? context.fetch(fetchRequest).first
    }
    
    func saveToWatchlist() {
        let newItem = Watchlist(context: moc)
        newItem.title = movie.title ?? "Unknown"
        newItem.id = Int32(movie.id)
        
        try? moc.save()
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
