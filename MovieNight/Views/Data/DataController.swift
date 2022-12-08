    //
    //  DataController.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MovieNight")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        }
        
        deleteObjects()
        
    }
    
    func deleteObjects() {
        let mediaRequest = NSFetchRequest<Media>(entityName: "Media")
        let personRequest = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            let mediaResults = try container.viewContext.fetch(mediaRequest)
            let personResults = try container.viewContext.fetch(personRequest)
            
            
            for media in mediaResults {
                    if media.watchlist {
                        media.isDiscoverObject = false
                        media.isSearchObject = false
                    } else {
                        container.viewContext.delete(media)
                    }
                }
            
            for person in personResults {
                container.viewContext.delete(person)
            }
            
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
}
