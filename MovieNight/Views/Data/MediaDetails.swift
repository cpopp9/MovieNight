    //
    //  MovieDetails.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/19/22.
    //

import Foundation

struct MediaDetails: Codable {
    
        // Movie and TV Details
    var genres: [Genre]?
    let status: String?
    let tagline: String?
    
        // Movie Details
    let runtime: Int?
    let imdb_id: String?
    
//    TV Details
    let type: String?
    let number_of_seasons: Int?
    
    struct Genre: Codable {
        let name: String
    }
}


