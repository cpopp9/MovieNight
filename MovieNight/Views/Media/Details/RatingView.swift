//
//  MovieRatingView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/18/22.
//

import SwiftUI

struct RatingView: View {
    let voteAverage: Double
    
    var body: some View {
        switch Int(voteAverage) {
        case 0..<2:
            return Text("★☆☆☆☆")
                .foregroundColor(.yellow)
        case 2..<4:
            return Text("★★☆☆☆")
                .foregroundColor(.yellow)
        case 4..<6:
            return Text("★★★☆☆")
                .foregroundColor(.yellow)
        case 6..<8:
            return Text("★★★★☆")
                .foregroundColor(.yellow)
        default:
            return Text("★★★★★")
                .foregroundColor(.yellow)
        }
    }
}

struct MovieRatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(voteAverage: 3.5)
    }
}
