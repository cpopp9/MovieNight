    //
    //  ContentView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct ContentView: View {
    var body: some View {
            
            TabView {
                
                DiscoverView()
                    .tabItem {
                        VStack {
                            Image(systemName: "sparkles.tv.fill")
                            Text("Discover")
                        }
                    }
                    .tag(0)
                
                MyMoviesView()
                    .tabItem {
                        VStack {
                            Image(systemName: "popcorn.fill")
                            Text("My Movies")
                        }
                    }
                    .tag(1)
                
                SearchView()
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }
                    .tag(2)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
