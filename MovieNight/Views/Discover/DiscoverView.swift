//
//  DiscoverView.swift
//  MovieNight
//
//  Created by Cory Popp on 9/29/22.
//

import SwiftUI

struct DiscoverView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeAdded, order: .forward)], predicate: NSPredicate(format: "isDiscoverObject == true")) var discoverResults: FetchedResults<Media>
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    
    @State var currentPage = 1
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("New and upcoming releases:")
                    
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(discoverResults) { media in
                            DiscoverPoster(media: media)
                        }
                        Image(systemName: "plus")
                            .padding()
                            .font(.system(size: 25))
                            .onAppear {
                                currentPage += 1
                                Task {
                                    await downloadDiscoveryMedia(year: 2022, page: currentPage)
                                }
                            }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Discover")
            .task {
                if discoverResults.isEmpty {
                    await downloadDiscoveryMedia(year: 2022, page: 1)
                }
            }
    }
    
    func downloadDiscoveryMedia(year: Int, page: Int) async {
        
        guard let discover = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&primary_release_year=\(year)&with_watch_monetization_types=flatrate") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: discover)
            
            if let decodedResponse = try? JSONDecoder().decode(MediaResults.self, from: data) {
                
                if let discoverResults = decodedResponse.results {
                    
                    for item in discoverResults {
                        dataController.CreateMediaObject(item: item, context: moc).isDiscoverObject = true
                    }
                }
            }
        } catch let error {
            print("Invalid Data \(error)")
        }
        
    }
    
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
