    //
    //  ContentView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 0
    @State private var tappedTwice: Bool = false
    @State private var discover = UUID()
    @State private var myMovies = UUID()
    @State private var search = UUID()
    @State private var settings = UUID()
    
    var body: some View {
        var handler: Binding<Int> { Binding(
            get: { self.tabSelection },
            set: {
                if $0 == self.tabSelection {
                    tappedTwice = true
                }
                self.tabSelection = $0
            }
        )}
        
        return ScrollViewReader { proxy in
            TabView(selection: handler) {
                
                NavigationView {
                    DiscoverView()
                        .id(discover)
                }
                .accentColor(.white)
                .tabItem {
                    Image(systemName: "sparkles.tv.fill")
                    Text("Discover")
                }
                .tag(0)
                
                NavigationView {
                    MyMoviesView()
                        .id(myMovies)
                }
                .accentColor(.white)
                .tabItem {
                    Image(systemName: "popcorn.fill")
                    Text("My Movies")
                }
                .tag(1)
                
                NavigationView {
                    SearchView()
                        .id(search)
                }
                .accentColor(.white)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(2)
                
                NavigationView {
                    SettingsView()
                        .id(settings)
                }
                .accentColor(.white)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
            }
            .onChange(of: tappedTwice, perform: { tapped in
                guard tappedTwice else { return }
                
                if tabSelection == 0 {
                    discover = UUID()
                } else if tabSelection == 1 {
                    myMovies = UUID()
                } else if tabSelection == 2 {
                    search = UUID()
                } else if tabSelection == 3 {
                    settings = UUID()
                }
                tappedTwice = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
