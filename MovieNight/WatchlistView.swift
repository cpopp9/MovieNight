//
//  WatchlistView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import CoreData
import SwiftUI

    // a convenient extension to set up the fetch request


struct WatchListView: View {
    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "watchlist == true")) var fetchRequest: FetchedResults<Movie>
//    @FetchRequest(entity: Movie.entity(), sortDescriptors: [], predicate: NSPredicate(format: "watchlist == true")) var watchList: FetchedResults<Movie>
//    @FetchRequest(fetchRequest: Movie.movieFetchRequest) var fetchRequest: FetchedResults<Movie>
    @FetchRequest(sortDescriptors: []) var movies: FetchedResults<Watchlist>

    
    
        
    
    var body: some View {
        VStack {
            List(movies, id: \.self) { media in
                Text(media.title ?? "Unknown")
            }
        }
    }
    
    
    
//    init() {
//        
//        
//        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "watchlist == true")
//        fetchRequest.fetchLimit = 1
//
////        let context = moc
//        let context = appDelegate.persistentContainer.viewContext
//        
//        object = try? context.fetch(fetchRequest).first
//    }
    
}
//
//struct WatchlistView_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchlistView()
//    }
//}
