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
                    Button("Save") {
                        Task {
                            await dataController.saveMedia()
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
                    dataController.deleteMediaObjects()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
