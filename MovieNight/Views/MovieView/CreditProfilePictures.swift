    //
    //  CreditProfilePictures.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 11/2/22.
    //

import SwiftUI

struct CreditProfilePictures: View {
    @ObservedObject var person: Person
    var body: some View {
        NavigationLink {
            PersonView(person: person)
        } label: {
            VStack {
                
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(person.wrappedProfilePath)")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                } placeholder: {
                    Image("profile_placeholder")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 150)
                }
                
                    //                Image(uiImage: person.wrappedPosterImage)
                    //                    .resizable()
                    //                    .aspectRatio(contentMode: .fit)
                    //                    .frame(width: 100)
                    //                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                    //                Text(person.wrappedName)
                    //                    .font(.caption)
                    //                    .foregroundColor(.secondary)
                    //                    .multilineTextAlignment(.center)
            }
//            .frame(width: 100)
        }
    }
}

    //struct CreditProfilePictures_Previews: PreviewProvider {
    //    static var previews: some View {
    //        CreditProfilePictures()
    //    }
    //}
