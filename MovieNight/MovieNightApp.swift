    //
    //  MovieNightApp.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

@main
struct MovieNightApp: App {
    
    @Environment(\.managedObjectContext) var moc
    
    @StateObject private var dataController = DataController()
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .light : .dark)
        }
    }
}
