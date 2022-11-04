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
            ZStack {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(person.wrappedProfilePath)")) { image in
                    image
                        .resizable()
                        .scaledToFit()
//                        .frame(width: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                } placeholder: {
                    Image("profile_placeholder")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                VStack(alignment: .trailing) {
                    Spacer()
                    Text(person.wrappedName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(5)
                        .background(Color.black)
                        
                        .
                }
            }
            .frame(width: 100)
        }
    }
}

    //struct CreditProfilePictures_Previews: PreviewProvider {
    //    static var previews: some View {
    //        CreditProfilePictures()
    //    }
    //}
