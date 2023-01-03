    //
    //  MovieNightApp.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

@main
struct MovieNightApp: App {
    @StateObject var dataController = DataController()
    @StateObject var mediaVM = MediaModel()
    @StateObject var personVM = PersonViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mediaVM)
                .environmentObject(personVM)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }   
}
