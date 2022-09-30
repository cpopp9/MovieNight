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
                SearchView()
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                    .tag(0)
                
                
                WatchListView()
                    .tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("Watch List")
                        }
                    }
                    .tag(1)
                
                
                DiscoverView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill.viewfinder")
                            Text("Discover")
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
