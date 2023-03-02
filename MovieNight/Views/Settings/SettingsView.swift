    //
    //  SettingsView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI
import SafariServices

struct SettingsView: View {
    @EnvironmentObject var mediaVM: MediaViewModel
    @Environment(\.managedObjectContext) var moc
    @State private var showingAlert = false
    
    var body: some View {
            Form {
                
                Section {
                    Button("Delete App Data") {
                        showingAlert = true
                    }
                }
                
                Section("About this app") {
                    Link("Rate this App", destination: URL(string: "https://apps.apple.com/us/app/movie-night-tv-movies/id1672641375?action=write-review")!)
                    Link("App Developer", destination: URL(string: "https://www.linkedin.com/in/coryjpopp/")!)
                }
                
                Section("Attributions") {
                    
                    HStack {
                        Image("tmdb_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        
                        Link("All movie data was provided by The Movie Database", destination: URL(string: "http://themoviedb.org")!)
                            .foregroundColor(.primary)
                        
                            .padding()
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Delete all movies?", isPresented: $showingAlert) {
                Button("Confirm", role: .destructive) {
                    mediaVM.deleteObjects(filter: .all, context: moc)
                }
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
