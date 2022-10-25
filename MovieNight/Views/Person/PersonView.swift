//
//  PersonView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/25/22.
//

import SwiftUI

struct PersonView: View {
    @ObservedObject var person: Person
    
    var body: some View {
            
                VStack {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(person.wrappedProfilePath)")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.red
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .clipShape(Circle())
                    
                    Text(person.wrappedName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 100)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(person: Person())
    }
}
