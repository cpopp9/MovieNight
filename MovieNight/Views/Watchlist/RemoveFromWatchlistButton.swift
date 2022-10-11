    //
    //  WatchlistRemoveFromWatchlistButton.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/11/22.
    //

import CoreData
import SwiftUI

struct RemoveFromWatchlistButton: View {
    @Environment(\.managedObjectContext) var moc
    let watchlistObject: WatchlistMedia
    
    var body: some View {
        
        Button() {
            deleteFromWatchlist()
        } label: {
            HStack {
                Image(systemName: "minus")
                Text("Remove from Watchlist")
            }
            .frame(maxWidth: .infinity)
        }
        .tint(.red)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .controlSize(.large)
        .padding()
    }
    
    func deleteFromWatchlist() {
        
        moc.delete(watchlistObject)
        
        try? moc.save()
    }
}
    //
    //    struct RemoveFromWatchlistButton_Previews: PreviewProvider {
    //        static var previews: some View {
    //            AddToWatchListButton()
    //        }
    //    }


