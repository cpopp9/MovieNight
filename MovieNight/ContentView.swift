//
//  ContentView.swift
//  MovieNight
//
//  Created by Cory Popp on 5/25/22.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    var movies = ["4j0PNHkMr5ax3IA8tjtxcmPU3QT", "6DrHO1jr3qVrViUO6s6kFiAGM7"]
    
    var body: some View {
        NavigationView {
            NavigationLink {
                MovieView()
            } label: {
                VStack(alignment: .leading) {
                    Image(movies[0])
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 5)
                    Text("Gravity")
                }.frame(width: 150)
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
