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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
