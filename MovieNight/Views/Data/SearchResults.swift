//
//  SearchResults.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import CoreData
import Foundation

struct Result: Codable {
    
    var id: Int
    var backdrop_path: String?
    var poster_path: String?
    var genre_ids: [Int]?
    var media_type: String?
    var original_language: String?
    var overview: String?
    var vote_average: Double?
    var vote_count: Int?
    
    
    // Movie Details
    var title: String?
    var original_title: String?
    
    // TV Details
    var name: String?
    var original_name: String?
    var first_air_date: String?
    
}

struct SearchResults: Codable {
    var results: [Result]?
}
