    //
    //  RecommendedMovies.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 10/21/22.
    //

import SwiftUI
import CoreData

struct CreditsView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest var credits: FetchedResults<Person>
    @ObservedObject var media: Media
    
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Credits")
                        .font(.title.bold())
                        .padding(.horizontal)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(credits.prefix(10), id: \.self) { person in
                            CreditProfilePictures(person: person)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .task {
            if credits.isEmpty {
                await dataController.getCredits(media: media)
            }
        }
    }
    
    init(media: Media) {
        _credits = FetchRequest<Person>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)], predicate: NSPredicate(format: "mediaCredit == %i", media.id))
        self.media = media
    }
}


    ////  CreditsView.swift
    ////  MovieNight
    ////
    ////  Created by Cory Popp on 10/24/22.
    ////
    //
    //import SwiftUI
    //
    //struct CreditsView: View {
    //    @FetchRequest var credits: FetchedResults<Person>
    //    @EnvironmentObject var dataController: DataController
    //
    //    var body: some View {
    //
    //        if credits.count > 0 {
    //
    //            VStack(alignment: .leading) {
    //
    //                VStack(alignment: .leading) {
    //                    Text("Credits")
    //                        .font(.title2.bold())
    //                        .padding(.horizontal)
    //                }
    //
    //                ScrollView(.horizontal, showsIndicators: false) {
    //
    //                    LazyHStack(alignment: .top, spacing: 10) {
    //                        ForEach(credits.prefix(10), id: \.name) { credit in
    //
    //                            NavigationLink {
    //                                PersonView(person: credit)
    //                            } label: {
    //
    //
    //                                VStack {
    //                                    Image(uiImage: credit.wrappedPosterImage)
    //                                        .resizable()
    //                                        .aspectRatio(contentMode: .fit)
    //                                        .frame(width: 100)
    //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
    //
    //                                    Text(credit.name ?? "--")
    //                                        .font(.caption)
    //                                        .foregroundColor(.secondary)
    //                                        .multilineTextAlignment(.center)
    //                                }
    //                                .frame(width: 100)
    //                            }
    //                        }
    //                    }
    //                }
    //                .padding(.horizontal)
    //            }
    //        }
    //    }
    //
    //
    //    init() {
    //
    //        _credits = FetchRequest<Person>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)])
    //
    //    }
    //
    //}
    //
    ////struct CreditsView_Previews: PreviewProvider {
    ////    static var previews: some View {
    ////        CreditsView()
    ////    }
    ////}
    //
    //
    ////if let profile = credit.profile_path {
    ////
    ////    VStack {
    ////        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(profile)")) { image in
    ////            image.resizable()
    ////        } placeholder: {
    ////            Color.red
    ////        }
    ////        .aspectRatio(contentMode: .fit)
    ////        .frame(width: 100)
    ////        .clipShape(RoundedRectangle(cornerRadius: 10))
    ////
    ////        Text(credit.name ?? "--")
    ////            .font(.caption)
    ////            .foregroundColor(.secondary)
    ////            .multilineTextAlignment(.center)
    ////    }
    ////    .frame(width: 100)
    ////}
