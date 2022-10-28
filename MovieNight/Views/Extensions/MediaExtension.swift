//
//  MediaExtension.swift
//  MovieNight
//
//  Created by Cory Popp on 10/28/22.
//

import Foundation
import CoreData

extension Media {
    public func detectExistingMedia(mediaID: Int, context: NSManagedObjectContext) -> Media? {
        let request: NSFetchRequest<Media> = Media.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", mediaID)
        
        if let object = try? context.fetch(request).first {
            return object
        }
        
        return nil
    }
}
