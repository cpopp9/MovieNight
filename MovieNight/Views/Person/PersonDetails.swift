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
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(person.wrappedProfilePath)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
            } placeholder: {
                Image("profile_placeholder")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(height: 150)
            }
            
            Text(person.wrappedName)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            Text(person.wrappedKnownFor)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                
                Text(person.wrappedBiography)
                    .frame(maxWidth: .infinity)
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

struct PersonDetails_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetails(person: Person())
    }
}
