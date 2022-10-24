    //
    //  CreditsView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/24/22.
    //

import SwiftUI

struct CreditsView: View {
    let credits: Credits
    var body: some View {
        
        if let credits = credits.cast {
            
            VStack(alignment: .leading) {
                Text("Credits")
                    .font(.title2.bold())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(alignment: .top, spacing: 10) {
                    ForEach(credits.prefix(10), id: \.name) { credit in
                        if let profile = credit.profile_path {
                            
                            VStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(profile)")) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.red
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Text(credit.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 100)
                        }
                    }
                    
                }
                
                
                
            }
        }
    }
}

    //struct CreditsView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        CreditsView()
    //    }
    //}
