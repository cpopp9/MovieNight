//
//  MovieTopDetails.swift
//  MovieNight
//
//  Created by Cory Popp on 10/24/22.
//

import SwiftUI

struct MovieTopDetails: View {
    let media: Media
    
    var body: some View {
        VStack {
            Image(uiImage: media.wrappedPosterImage)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.trailing)
            
                // Initial details
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
                    MediaRatingView(rating: 4)
                    Text("(\(media.vote_count) ratings)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            AddToWatchListButton(media: media)
                .padding(.bottom)
            
            MovieDetailView(media: media)
            
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

//struct MovieTopDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieTopDetails()
//    }
//}
