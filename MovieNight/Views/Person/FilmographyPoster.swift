    //
    //  SimilarPostersView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 11/2/22.
    //

import SwiftUI

struct FilmographyPostersView: View {
    @ObservedObject var media: Media
    var body: some View {
        NavigationLink {
            MovieView(media: media)
        } label: {
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } placeholder: {
                Image("poster_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            
            
//            Image(uiImage: media.wrappedPosterImage)
//                .resizable()
//                .scaledToFit()
//                .frame(height: 200)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

    //struct SimilarPostersView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SimilarPostersView()
    //    }
    //}
