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
    @StateObject private var searchModel = SearchModel()
    
    @StateObject private var dataController = DataController()
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(searchModel)
                .preferredColorScheme(isDarkMode ? .light : .dark)
                .onChange(of: scenePhase) { newPhase in
                                if newPhase == .inactive {
                                    print("Inactive")
                                } else if newPhase == .active {
                                    print("Active")
                                } else if newPhase == .background {
                                    print("Background")
                                    try? dataController.container.viewContext.save()
                                }
                            }
        }
    }
}
