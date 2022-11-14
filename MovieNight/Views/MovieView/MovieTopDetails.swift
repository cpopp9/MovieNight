    //
    //  MovieTopDetails.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/24/22.
    //

import SwiftUI

struct MovieTopDetails: View {
    @ObservedObject var media: Media
    
    var body: some View {
        VStack(alignment: .center) {
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.trailing)
                
            } placeholder: {
                Image("poster_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.trailing)
            }
            
            VStack {
                Text(media.wrappedTitle)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                
                HStack {
                    Text(media.wrappedReleaseDate)
                        .foregroundColor(.secondary)
                    Text("·")
                    Text(media.wrappedStatus)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    MediaRatingView(voteAverage: media.vote_average)
                    Text("(\(media.vote_count) ratings)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
    }
}

struct MovieTopDetails_Previews: PreviewProvider {
    static var previews: some View {
        MovieTopDetails(media: Media())
    }
}
