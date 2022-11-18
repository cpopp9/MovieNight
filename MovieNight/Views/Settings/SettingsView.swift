    //
    //  SettingsView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI
import SafariServices

struct SettingsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    @State private var showingAlert = false
    
    var body: some View {
            Form {
                
                Section {
                    Button("Delete App Data") {
                        showingAlert = true
                    }
                    Button("Save") {
                        Task {
                            dataController.saveMedia(context: moc)
                        }
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
                    dataController.deleteObjects(filter: .all)
                }
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
