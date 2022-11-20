    //
    //  DiscoverPosters.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 11/2/22.
    //

import SwiftUI

struct DiscoverPoster: View {
    @ObservedObject var media: Media
    var body: some View {
        NavigationLink {
            MovieView(media: media)
        } label: {
            VStack {
                
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)"), transaction: Transaction(animation: .spring())) { phase in
                    switch phase {
                    case .empty:
                        Color.black.opacity(0.1)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    case .failure(_):
                        Color.black.opacity(0.1)
                        
                    @unknown default:
                        Color.black.opacity(0.1)
                    }
                }
                .aspectRatio(2/3, contentMode: .fill)
                .scaledToFit()
//                .frame(height: 250)
                
                
                Text(media.wrappedTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
            }
        }
    }
}

struct DiscoverPoster_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPoster(media: Media())
    }
}
