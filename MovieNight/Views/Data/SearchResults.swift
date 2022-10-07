//
//  SearchResults.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import Foundation

struct SearchResult: Codable {
    
    var id: Int
    var backdrop_path: String?
    var poster_path: String?
    var genre_ids: [Int]?
    var media_type: String?
    var original_language: String?
    var overview: String?
    var vote_average: Double?
    var vote_count: Int?
    var popularity: Double?
    
    
    // Movie Details
    var title: String?
    var original_title: String?
    var release_date: String?
    
    // TV Details
    var name: String?
    var original_name: String?
    var first_air_date: String?
    
    // Person Details
    var known_for_department: String?
    var profile_path: String?
    
}

struct SearchResults: Codable {
    var results: [SearchResult]?
}

