//
//  MovieView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import SwiftUI

struct MovieView: View {
    let movie: Movie
    
    var body: some View {
        Text(movie.title ?? "Unknown")
    }
}

//struct MovieView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieView()
//    }
//}
