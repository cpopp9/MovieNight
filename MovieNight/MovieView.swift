    //
    //  MovieView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import CoreData
import SwiftUI

struct MovieView: View {
    let movie: Movie
    @Environment(\.managedObjectContext) var moc
//    @State var object: Watchlist?
    
    var body: some View {
        VStack {
            Text(movie.title ?? "Unknown")
            
            AddToWatchListButton(movie: movie)
    
        }
    }
    
//    func checkMovie(contentId: Int) {
//        let fetchRequest: NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %i", contentId)
//        fetchRequest.fetchLimit = 1
//
//        let context = moc
//
//        object = try? context.fetch(fetchRequest).first
//    }
    
}

    //struct MovieView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MovieView()
    //    }
    //}
