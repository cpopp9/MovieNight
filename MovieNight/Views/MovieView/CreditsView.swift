//
//  CreditsView.swift
//  MovieNight
//
//  Created by Cory Popp on 10/24/22.
//

import SwiftUI

struct CreditsView: View {
    @FetchRequest var credits: FetchedResults<Person>
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        
        if credits.count > 0 {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Credits")
                        .font(.title2.bold())
                        .padding(.horizontal)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    LazyHStack(alignment: .top, spacing: 10) {
                        ForEach(credits.prefix(10), id: \.name) { credit in
                            
                            NavigationLink {
                                PersonView(person: credit)
                            } label: {
                                
                                
                                VStack {
                                    Image(uiImage: credit.wrappedPosterImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text(credit.name ?? "--")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 100)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    
    init() {
        
        _credits = FetchRequest<Person>(sortDescriptors: [SortDescriptor(\.popularity, order: .reverse)])
        
    }
    
}

//struct CreditsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditsView()
//    }
//}


//if let profile = credit.profile_path {
//
//    VStack {
//        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(profile)")) { image in
//            image.resizable()
//        } placeholder: {
//            Color.red
//        }
//        .aspectRatio(contentMode: .fit)
//        .frame(width: 100)
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//
//        Text(credit.name ?? "--")
//            .font(.caption)
//            .foregroundColor(.secondary)
//            .multilineTextAlignment(.center)
//    }
//    .frame(width: 100)
//}
