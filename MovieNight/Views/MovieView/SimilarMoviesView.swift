    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI
import CoreData

struct SimilarMoviesView: View {
    @FetchRequest var similarMedia: FetchedResults<SimilarMedia>
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
//    @State var similar: SimilarMedia?
//    @ObservedObject var media: Media
    
    var body: some View {
        VStack {
            
                if similarMedia.count > 0 {
                    VStack(alignment: .leading) {
                        
                        
                        VStack(alignment: .leading) {
                            Text("You might also like")
                                .font(.title.bold())
                                .padding(.horizontal)
                        }
                        
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(similarMedia) { similar in
                                    ForEach(similar.similarMedia) { media in
                                    NavigationLink {
                                        MovieView(media: media)
                                    } label: {
                                        Image(uiImage: media.wrappedPosterImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    init(similarTo: Int) {
        _similarMedia = FetchRequest<SimilarMedia>(sortDescriptors: [], predicate: NSPredicate(format: "id == %i", similarTo))
    }
    
}

