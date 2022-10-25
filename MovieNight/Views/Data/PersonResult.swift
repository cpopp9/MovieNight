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

//switch Int(voteAverage) {
//case 0..<2:
//    return Text("★☆☆☆☆")
//        .foregroundColor(.yellow)
//case 2..<4:
//    return Text("★★☆☆☆")
//        .foregroundColor(.yellow)
//case 4..<6:
//    return Text("★★★☆☆")
//        .foregroundColor(.yellow)
//case 6..<8:
//    return Text("★★★★☆")
//        .foregroundColor(.yellow)
//default:
//    return Text("★★★★★")
//        .foregroundColor(.yellow)
//}

