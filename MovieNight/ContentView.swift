//
//  ContentView.swift
//  MovieNight
//
//  Created by Cory Popp on 5/25/22.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            Group {
                NavigationLink {
                    Settings()
                } label: {
                    Text("Settings")
                }
                NavigationLink {
                    MovieView()
                } label: {
                    VStack(alignment: .leading) {
                        Image("Gravity-movie-poster")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 5)
                        Text("Gravity")
                    }.frame(width: 150)
                }
                
            }
            .navigationTitle("Movie List")
            .searchable(text: $searchText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
