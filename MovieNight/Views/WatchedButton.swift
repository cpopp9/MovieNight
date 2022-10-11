//
//  WatchedButton.swift
//  MovieNight
//
//  Created by Cory Popp on 10/5/22.
//

import SwiftUI

struct WatchedButton: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var media: WatchlistMedia
    
    var body: some View {
        Button() {
            media.watched.toggle()
            
            if moc.hasChanges {
                try? moc.save()
            }
            
            
        } label: {
            HStack {
                Image(systemName: media.watched ? "checkmark.circle.fill" : "checkmark.circle")
                Text("Watched")
            }
        }
    }
}

//struct WatchedButton_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchedButton()
//    }
//}
