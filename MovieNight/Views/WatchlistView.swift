//
//  WatchlistView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import CoreData
import SwiftUI

struct WatchListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var movies: FetchedResults<Watchlist>
    
    var body: some View {
        NavigationView {
            VStack {
                List(movies, id: \.self) { media in
                    NavigationLink {
                        WatchListMovieView(movie: media)
                    } label: {
                        Text(media.title ?? "Unknown")
                    }
                }
            }
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
