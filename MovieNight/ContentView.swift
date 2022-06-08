//
//  ContentView.swift
//  MovieNight
//
//  Created by Cory Popp on 5/25/22.
//

import SwiftUI

struct ContentView: View {
    @State var selectedMovie: String = "Gravity"
    @State var movieList: [String] = ["Indiana Jones and the Raiders of the Lost Ark", "Gravity", "Tommy Boy", "Alien"]
    
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    Settings()
                } label: {
                    Text("Settings")
                }
                NavigationLink {
                    MovieView()
                } label: {
                    Text("Gravity")
                }
            }
            .navigationTitle("Movie Night 🍿")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
