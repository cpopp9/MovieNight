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
            VStack {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)")) { image in
                    image
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                } placeholder: {
                    Image("poster_placeholder")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .aspectRatio(2/3, contentMode: .fill)
                .frame(height: 250)
                
                Text(media.wrappedTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
            }
        }
    }
}

    //struct SimilarPostersView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SimilarPostersView()
    //    }
    //}
