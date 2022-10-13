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
    @ObservedObject var media: Movie
    
    var body: some View {
        
        VStack {
            Button() {
                
                media.watchlist.toggle()
                
            } label: {
                HStack {
                    Image(systemName: media.watchlist ? "minus" : "plus")
                    Text(media.watchlist ? "Remove from Watchlist" : "Add to watchlist")
                }
                .frame(maxWidth: .infinity)
            }
            .tint(media.watchlist ? .red : .blue)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            .padding()
            
            Button() {
                media.watched.toggle()
            } label: {
                Text("Watched")
                Image(systemName: media.watched ? "checkmark.circle.fill" : "checkmark.circle")
            }
            .disabled(!media.watchlist)
        }
    }
}
    //
    //    struct AddToWatchListButton_Previews: PreviewProvider {
    //        static var previews: some View {
    //            AddToWatchListButton()
    //        }
    //    }
