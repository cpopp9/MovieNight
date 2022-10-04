//
//  DiscoverResults.swift
//  MovieNight
//
//  Created by Cory Popp on 10/4/22.
//

import Foundation

struct DiscoverResult: Codable {
    
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

struct DiscoverResults: Codable {
    var results: [DiscoverResult]?
}
