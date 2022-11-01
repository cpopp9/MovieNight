//
//  PersonView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/25/22.
//

import SwiftUI

struct PersonDetails: View {
    @ObservedObject var person: Person
    @State var expandBiography = false
    
    var body: some View {
        
        VStack {
            Image(uiImage: person.wrappedPosterImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(person.wrappedName)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            Text(person.wrappedKnownFor)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                
                Text(person.wrappedBiography)
                    .lineLimit(expandBiography ? 20 : 3)
                
                
                Button() {
                    expandBiography.toggle()
                } label: {
                    Text(expandBiography ? "Read Less" : "Read More")
                        .font(.body.bold())
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding()
    }
}

//struct PersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonDetails(person: Person())
//    }
//}