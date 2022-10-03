//
//  SettingsView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    @FetchRequest(sortDescriptors: []) var movies: FetchedResults<Watchlist>
    @Environment(\.managedObjectContext) var moc
    @State private var showingAlert = false
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Light Mode", isOn: $isDarkMode)
                }
                
                Section {
                    Button("Delete App Data") {
                        showingAlert = true
                    }
                }
                
                Section("About this app") {
                    Text("Rate this app")
                    Text("App Developer")
                }
                
                Section("Attributions") {
                    
                    HStack {
                        Image("tmdb_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        
                            Text("All movie data was provided by The Movie Database")
                    
                        .padding()
                    }
                    
                    NavigationLink {
                        AttributionsView()
                    } label: {
                        Text("Software Attributions")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Delete all movies?", isPresented: $showingAlert) {
                Button("Confirm", role: .destructive) {
                    deleteCache()
                }
            }
        }
    }
    
    func deleteCache() {
        for movie in movies {
            moc.delete(movie)
            try? moc.save()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
