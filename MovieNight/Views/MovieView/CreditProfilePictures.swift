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
                Image(uiImage: person.wrappedPosterImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
//                Text(person.wrappedName)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .multilineTextAlignment(.center)
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
