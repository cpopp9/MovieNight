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
    @Environment(\.scenePhase) var scenePhase
    
    
    @StateObject private var dataController = DataController()
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .light : .dark)
                .onChange(of: scenePhase) { newPhase in
                                if newPhase == .inactive {
                                    print("Inactive")
                                } else if newPhase == .active {
                                    print("Active")
                                } else if newPhase == .background {
                                    print("Background")
                                    dataController.clearMedia(filterKey: "search")
                                    dataController.clearMedia(filterKey: "discover")
                                    try? dataController.container.viewContext.save()
                                }
                            }
        }
    }
}
