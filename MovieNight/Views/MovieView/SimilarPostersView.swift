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
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(media.wrappedPosterPath)"), transaction: Transaction(animation: .spring())) { phase in
                switch phase {
                case .empty:
                    Image("poster_placeholder")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                case .success(let image):
                    image
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                case .failure(_):
                    Image("poster_placeholder")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                @unknown default:
                    Image("poster_placeholder")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .aspectRatio(2/3, contentMode: .fill)
            .frame(height: 250)
            

        }
    }
}

    //struct SimilarPostersView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SimilarPostersView()
    //    }
    //}
