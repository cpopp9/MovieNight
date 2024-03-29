    //
    //  CreditDetails.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/24/22.
    //

import Foundation

struct Credits: Codable {
    
    var cast: [Cast]?

}

struct Cast: Codable {
    
    let id: Int
    let name: String
    let popularity: Double
    let profile_path: String?
    let credit_id: String
    let known_for_department: String?
    
}
