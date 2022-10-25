//
//  MovieDetailView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/24/22.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var media: Media
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Overview")
                        .font(.title2.bold())
                    Text("Sci-fi, Adventure, Action")
                        .font(.subheadline)
                    Text("\(media.runtime) minutes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
                Spacer()
                
                Link(destination: URL(string: media.wrappedIMDBUrl)!) {
                    Image("imdb_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .padding(.trailing)
                }
            }
            VStack(alignment: .leading) {
                
                if let tagline = media.tagline {
                    if tagline != "" {
                        Text(tagline)
                            .font(.title3.bold())
                            .padding(.bottom)
                    }
                }
                
                Text(media.wrappedOverview)
                    .padding(.bottom)
                
            }
        }
        .padding()
    }
}

//struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailView()
//    }
//}
