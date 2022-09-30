//
//  SearchResults.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import Foundation

struct Result: Codable {
    var id: Int
    var title: String?
    var name: String?
}

struct SearchResults: Codable {
    var results: [Result]?
}

struct WatchList: Codable {
    var results: [Result]?
}
