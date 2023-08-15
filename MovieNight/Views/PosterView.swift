//
//  PosterView.swift
//  MovieNight
//
//  Created by Cory Popp on 3/1/23.
//

import SwiftUI

struct PosterView: View {
    @ObservedObject var media: Media
    var body: some View {
        NavigationLink {
            MovieView(media: media)
        } label: {
            VStack {
                
                // Loads and displays image asynchronously from URL. AsyncImage inherently contains phases that include fallbacks for if the image fails to load, or if the URL doesn't contain an image.
                
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
                
                
                Text(media.wrappedTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
            }
        }
    }
}

struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(media: Media())
    }
}
