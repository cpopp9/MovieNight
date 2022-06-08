//
//  MovieView.swift
//  MovieNight
//
//  Created by Cory Popp on 6/2/22.
//

import SwiftUI

struct MovieView: View {
    var body: some View {
        ScrollView {
        VStack(spacing: 30) {
            HStack {
                VStack(alignment: .leading){
                    Text("Gravity")
                        .font(.title.bold())
                    Text("2013")
                }
                Spacer()
            }
           
            
            Image("Gravity-movie-poster")
                .resizable()
                .scaledToFit()
                .shadow(radius: 5)
            
            Button("Add to watch list") { }
                .buttonStyle(.borderedProminent)
            
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment:.leading) {
                        Text("Information")
                            .font(.title3.bold())
                        Text("Action, Drama, Sci-Fi")
                            .font(.subheadline)
                    }
                    
                    Text("Two astronauts work together to survive after an accident leaves them stranded in space.")
                }
                Spacer()
            }
        }.padding(.all, 50)
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
