    //
    //  MovieNightApp.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

@main
struct MovieNightApp: App {
    @StateObject private var dataController = DataController()
    
//    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(.dark)
//                .onChange(of: scenePhase) { newPhase in
//                    if newPhase == .inactive {
//                    } else if newPhase == .active {
//                    } else if newPhase == .background {
//                    }
//                }
        }
    }   
}
