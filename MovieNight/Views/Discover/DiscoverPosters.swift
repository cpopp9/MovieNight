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
                
                Image(uiImage: media.wrappedPosterImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
                    .frame(maxHeight: 300)
                
                
                Text(media.wrappedTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
            }
        }
    }
}
