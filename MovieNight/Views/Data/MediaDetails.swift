//
//  MovieDetails.swift
//  MovieNight
//
//  Created by Cory Popp on 10/19/22.
//

import Foundation

struct MediaDetails: Codable {
    var genres: [genre]
    let imdb_id: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String
    
    
    struct genre: Codable {
        let name: String
    }
}


