//
//  SimilarPostersView.swift
//  MovieNight
//
//  Created by Cory Popp on 11/2/22.
//

import SwiftUI

struct SimilarPostersView: View {
    @ObservedObject var media: Media
    var body: some View {
        NavigationLink {
            MovieView(media: media)
        } label: {
            Image(uiImage: media.wrappedPosterImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

//struct SimilarPostersView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimilarPostersView()
//    }
//}
