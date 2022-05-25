//
//  ContentView.swift
//  MovieNight
//
//  Created by Cory Popp on 5/25/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Hello, earth!")
            }
                
                Section {
                    Text("Movies")
                    Text("TV Shows")
            }
            }
        .navigationTitle("Put.io")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
