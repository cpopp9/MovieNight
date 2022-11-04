//
//  SearchResults.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import Foundation

struct MediaResult: Codable {
    
    let id: Int
    let backdrop_path: String?
    let poster_path: String?
    let genre_ids: [Int]?
    let media_type: String?
    let original_language: String?
    let overview: String?
    let vote_average: Double?
    let vote_count: Int?
    let popularity: Double?
    
    // Movie Details
    let title: String?
    let original_title: String?
    let release_date: String?
    
    // TV Details
    let name: String?
    let original_name: String?
    let first_air_date: String?
    
    // Person Details
    let known_for_department: String?
    let profile_path: String?
    
}

struct MediaResults: Codable {
    var results: [MediaResult]?
    var crew: [MediaResult]?
}

