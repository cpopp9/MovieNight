//
//  PersonFilmography.swift
//  MovieNight
//
//  Created by Cory Popp on 10/25/22.
//

import SwiftUI

struct PersonFilmography: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "isDiscoverObject == true")) var filmography: FetchedResults<Media>
    
    @EnvironmentObject var dataController: DataController
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Filmography:")
            
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns) {
                ForEach(filmography) { media in
                    NavigationLink {
                        MovieView(media: media)
                    } label: {
                        VStack {
                            Image(uiImage: media.wrappedPosterImage)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .scaledToFit()
                                .frame(maxHeight: 300)
                            
                            Text(media.wrappedTitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 15)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

//struct PersonFilmography_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonFilmography(dataController: DataController)
//    }
//}
