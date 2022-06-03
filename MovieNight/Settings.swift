//
//  Menu.swift
//  MovieNight
//
//  Created by Cory Popp on 6/2/22.
//

import SwiftUI

struct Settings: View {
    @State private var darkMode = false
    let appVersion: String = "0.1"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("v\(appVersion)")
                } header: {
                    Text("About MovieNight")
                }
                
                Section {
                    Text("Email Us")
                } header: {
                    Text("Support")
                }
                
                Section{
                    Toggle("Enable Dark Mode", isOn: $darkMode)
                    
                    if darkMode {
                                   Text("enable dark mode")
                               }
                    
                } header: {
                    Text("Features")
                }
                
                Section {
                    Button("Rate on the App Store", action: deleteData)
                    Button("Clear Cache", action: deleteData)
                    Button("Export Data", action: deleteData)
                    Button("Delete All Data", action: deleteData)
                } header: {
                    Text("Meta")
                }
            }
            .navigationTitle("Settings")
        }
    }
    
}

func rateApp() {}
func clearCache() {}
func exportData() {}
func deleteData() {}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
