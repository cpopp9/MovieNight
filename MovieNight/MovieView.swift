//
//  MovieView.swift
//  MovieNight
//
//  Created by Cory Popp on 6/2/22.
//

import SwiftUI

struct MovieView: View {
    var body: some View {
        VStack(spacing: 30) {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Gravity")
                        .foregroundStyle(.primary)
                        .font(.title.bold())
                    Text("2013")
                        .foregroundStyle(.secondary)
                    
                }.padding()
                Spacer()
            }
            
            
            VStack {
                Image("Gravity-movie-poster")
                
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 5)
                    .frame(width: 300)
                
                
                Button("Add to watch list") { }
                    .buttonStyle(.borderedProminent)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Information")
                        .foregroundStyle(.primary)
                        .font(.title)
                    Text("Two astronauts work together to survive after an accident leaves them stranded in space.")
                }.padding()
                Spacer()
            }
            
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
