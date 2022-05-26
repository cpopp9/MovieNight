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
                Section {
                    Text("Hello, movie lovers!")
                    Text("What would you like to watch?")
            }
                
                Section {
                    Picker("Select a movie", selection: $selectedMovie) {
                        ForEach(movieList, id: \.self) {
                            Text($0)
                        }
                    }
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
