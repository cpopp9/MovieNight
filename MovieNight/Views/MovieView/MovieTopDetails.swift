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
            
//            Image(uiImage: media.wrappedPosterImage)
//                .resizable()
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .scaledToFit()
//                .frame(height: 300)
//                .padding(.trailing)
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)"), transaction: Transaction(animation: .spring())) { phase in
                switch phase {
                case .empty:
                    Color.black.opacity(0.1)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                case .failure(_):
                    Color.black.opacity(0.1)
                    
                @unknown default:
                    Color.black.opacity(0.1)
                }
            }
            .frame(height: 300)
            .padding(.bottom)
            .border(.blue)
            
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
