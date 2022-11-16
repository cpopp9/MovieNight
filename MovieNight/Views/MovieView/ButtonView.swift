    //
    //  AddToWatchListButton.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/30/22.
    //

import CoreData
import SwiftUI

struct ButtonView: View {
    @FetchRequest var mediaResults: FetchedResults<Media>
    
    var watchlist: Bool {
        for media in mediaResults {
            if media.watchlist == true {
                return true
            }
        }
        return false
    }
    
    var watched: Bool {
        for media in mediaResults {
            if media.watched == true {
                return true
            }
        }
        return false
    }
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        
        VStack {
            Button() {
                
                watchlist ? removeFromWatchlist() : addToWatchlist()
                
                Task {
                    await dataController.saveMedia()
                }
                
            } label: {
                HStack {
                    Image(systemName: watchlist ? "minus" : "plus")
                    Text(watchlist ? "Remove from My Movies" : "Add to My Movies")
                }
                .frame(maxWidth: .infinity)
            }
            .tint(watchlist ? Color(.systemRed) : Color(.systemBlue))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            .padding(.top)
            
            Button() {
                
                watched ? unmarkWatched() : markWatched()
                
                Task {
                    await dataController.saveMedia()
                }
                
            } label: {
                HStack {
                    Image(systemName: watched ? "checkmark.circle.fill" : "checkmark.circle")
                    Text(watched ? "Watched" : "Not Watched")
                }
                .frame(maxWidth: .infinity)
            }
            .tint(watched ? Color(.systemGreen) : Color(.gray))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            .disabled(!watchlist)
        }
        .padding(.horizontal)
    }
    
    init(mediaID: Int) {
        _mediaResults = FetchRequest<Media>(sortDescriptors: [], predicate: NSPredicate(format: "id == %i", mediaID))
        
    }
    
    func markWatched() {
        for media in mediaResults {
            media.watched = true
        }
    }
    
    func unmarkWatched() {
        for media in mediaResults {
            media.watched = false
        }
    }
    
    func addToWatchlist() {
        for media in mediaResults {
            media.watchlist = true
        }
    }
    
    func removeFromWatchlist() {
        for media in mediaResults {
            media.watchlist = false
        }
    }
    
    
}

    //struct ButtonView_Previes: PreviewProvider {
    //    static var previews: some View {
    //        ButtonView()
    //    }
    //}
