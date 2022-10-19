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
    @ObservedObject var media: Media
    
    var body: some View {
        
        VStack {
            Button() {
                media.watchlist.toggle()
            } label: {
                HStack {
                    Image(systemName: media.watchlist ? "minus" : "plus")
                    Text(media.watchlist ? "Remove from My Movies" : "Add to My Movies")
                }
                .frame(maxWidth: .infinity)
            }
            .tint(media.watchlist ? Color(.systemRed) : Color(.systemBlue))
//            .tint(media.watchlist ? Color(.systemRed) : Color("add"))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            .padding(.top)
            
            Button() {
                media.watched.toggle()
            } label: {
                HStack {
                    Image(systemName: media.watched ? "checkmark.circle.fill" : "checkmark.circle")
                    Text(media.watched ? "Watched" : "Not Watched")
                }
                .frame(maxWidth: .infinity)
            }
            .tint(media.watched ? Color(.systemGreen) : Color(.gray))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            .disabled(!media.watchlist)
        }
    }
}
    
        struct AddToWatchListButton_Previews: PreviewProvider {
            static var previews: some View {
                AddToWatchListButton(media: Media())
            }
        }
