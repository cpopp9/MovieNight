//
//  PersonView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/25/22.
//

import SwiftUI

struct PersonDetails: View {
    @ObservedObject var person: Person
    
    var body: some View {
        
        VStack {
            Image(uiImage: person.wrappedPosterImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(person.wrappedName)
                .font(.title.bold())
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

//struct PersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonDetails(person: Person())
//    }
//}
