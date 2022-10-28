    //
    //  AddToWatchListButton.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/30/22.
    //

import CoreData
import SwiftUI

struct AddToWatchListButton: View {
    @ObservedObject var media: Media
    @EnvironmentObject var dataController: DataController
    
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
        .padding(.horizontal)
    }
    
//    func overwriteObject(media: Media) {
//        let request: NSFetchRequest<Media> = Media.fetchRequest()
//        request.fetchLimit = 1
//        request.predicate = NSPredicate(format: "id == %i && watchlist == true", Int(media.id))
//        
//        if let object = try? dataController.container.viewContext.fetch(request).first {
//            watchlistObject = object
//        }
//    }
}
    
//        struct AddToWatchListButton_Previews: PreviewProvider {
//            static var previews: some View {
//                AddToWatchListButton(media: Media())
//            }
//        }
