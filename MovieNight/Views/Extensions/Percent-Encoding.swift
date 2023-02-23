//
//  Percent-Encoding.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import Foundation

// Formats strings to be read correctly by API query by replacing spaces with %

extension String {
  func formatQuery() -> String {
    let unreserved = "-._~/?"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)
      return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)!
  }
}
