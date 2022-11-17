//
//  PersonDetails.swift
//  MovieNight
//
//  Created by Cory Popp on 10/25/22.
//

import Foundation

struct PersonResult: Codable {
    
    let biography: String?
    let birthday: String?
    let deathday: String?
    let id: Int
    let imdb_id: String?
    let known_for_department: String?
    let name: String
    let place_of_birth: String?
    let popularity: Double?
    let profile_path: String?
    let gender: Int?
    
}

