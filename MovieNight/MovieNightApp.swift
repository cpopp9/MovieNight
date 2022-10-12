    //
    //  MovieNightApp.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

@main
struct MovieNightApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @Environment(\.managedObjectContext) var moc
    
    @StateObject private var dataController = DataController()
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSearchMedia == true")) var searchResults: FetchedResults<Movie>
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .light : .dark)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("active")
            case .inactive:
                print("inactive")
            case .background:
                print("background")
                saveContext()
            }
        }
    }
    
//    func clearSearchMedia() {
//        for media in searchResults {
//            moc.delete(media)
//        }
//    }
    
    func saveContext() {
        
//        clearSearchMedia()
        
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                let error = error as NSError
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
