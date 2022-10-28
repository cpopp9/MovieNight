//
//  SimilarTest.swift
//  MovieNight
//
//  Created by Cory Popp on 10/28/22.
//

import SwiftUI

struct SimilarTest: View {
    @ObservedObject var media: Media
    var body: some View {
        
        if let similar = media.similarMedia {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(similar.mediaArray, id: \.self) { media in
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
                .padding(.horizontal)
            }
        }
    }
}

//struct SimilarTest_Previews: PreviewProvider {
//    static var previews: some View {
//        SimilarTest()
//    }
//}
