//
//  MovieRatingView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/18/22.
//

import SwiftUI

struct MediaRatingView: View {
    let rating: Int
    
    var body: some View {
        switch rating {
        case 1:
            return Text("★☆☆☆☆")
                .foregroundColor(.yellow)
        case 2:
            return Text("★★☆☆☆")
                .foregroundColor(.yellow)
        case 3:
            return Text("★★★☆☆")
                .foregroundColor(.yellow)
        case 4:
            return Text("★★★★☆")
                .foregroundColor(.yellow)
        default:
            return Text("★★★★★")
                .foregroundColor(.yellow)
        }
    }
}

//struct MovieRatingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieRatingView(rating: 3)
//    }
//}
