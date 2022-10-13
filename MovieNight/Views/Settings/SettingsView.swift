    //
    //  SettingsView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI
import SafariServices

struct SettingsView: View {
    @FetchRequest(sortDescriptors: []) var movies: FetchedResults<Movie>
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
                
                Section("Save") {
                    
                    
                    Button() {
                        do {
                            try moc.save()
                            print("moc saved")
                        } catch {
                            print("could not save")
                        }
                } label: {
                    Text("Save App Data")
                }
            }
            
            Section("About this app") {
                Text("Rate this app")
                Link("App Developer", destination: URL(string: "https://www.linkedin.com/in/coryjpopp/")!)
            }
            
            Section("Attributions") {
                
                HStack {
                    Image("tmdb_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    
                        //                            Text("All movie data was provided by The Movie Database")
                    Link("All movie data was provided by The Movie Database", destination: URL(string: "http://themoviedb.org")!)
                        .foregroundColor(.primary)
                    
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