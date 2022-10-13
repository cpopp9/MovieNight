    //
    //  DiscoverView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct DiscoverView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isDiscoverMedia == true")) var discoverResults: FetchedResults<Movie>

    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                        Text("New and upcoming releases:")

                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(discoverResults) { media in
                            NavigationLink {
                                MovieView(media: media)
                            } label: {
                                VStack {
                                    if let posterImage = media.posterImage {
                                        Image(uiImage: posterImage)
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .scaledToFit()
                                            .frame(maxHeight: 300)
                                    }
                                    
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
            .navigationTitle("Discover")
            .toolbar {
                Button() {
                    Task {
                        await loadDiscovery()
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .accentColor(.white)
    }


    func loadDiscovery() async {

//        for object in discoverResults {
//                moc.delete(object)
//        }

        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=9cb160c0f70956da44963b0444417ee2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            fatalError("Invalid URL")
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode(DiscoverResults.self, from: data) {

                if let searchResults = decodedResponse.results {

                    for item in searchResults {
                        DiscoverItem(item: item)
                    }
                    
//                    downloadBackdrops()
                }
                DispatchQueue.main.async {
                    downloadPosters()
                    downloadBackdrops()
                }
            }
        } catch {
            print("Invalid Data")
        }
    }
    
    func downloadPosters() {
        
            for media in discoverResults {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w1280\(media.wrappedPosterPath)")!
                
                    URLSession.shared.dataTask(with: url) { data, _, error in
                        guard let data = data, error == nil else {
                            return
                        }
                        
                        media.posterImage = UIImage(data: data)
                        
                    }.resume()
            }
    }
    
    func downloadBackdrops() {

            for media in discoverResults {

                let url = URL(string: "https://image.tmdb.org/t/p/w1280\(media.wrappedBackdropPath)")!

                    URLSession.shared.dataTask(with: url) { data, _, error in
                        guard let data = data, error == nil else {
                            return
                        }

                        media.backdropImage = UIImage(data: data)

                    }.resume()
            }
    }

    func DiscoverItem(item: DiscoverResult) {
        let newItem = Movie(context: moc)
        newItem.title = item.title ?? "Unknown"
        newItem.id = Int32(item.id)
        newItem.backdrop_path = item.backdrop_path
        newItem.poster_path = item.poster_path
        newItem.media_type = "movie"
        newItem.original_language = item.original_language
        newItem.original_title = item.original_title
        newItem.overview = item.overview
        newItem.release_date = item.release_date
        newItem.watchlist = false
        newItem.isSearchMedia = false
        newItem.isDiscoverMedia = true
        newItem.posterImage = UIImage(named: "poster_placeholder")

        if let date = item.release_date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsed = formatter.date(from: date) {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: parsed)
                newItem.release_date = "\(year)"
            }
        }


                if let vote_average = item.vote_average {
                    newItem.vote_average = vote_average
                }

                if let vote_count = item.vote_count {
                    newItem.vote_count = Int16(vote_count)
                }
            }

        }

        struct DiscoverView_Previews: PreviewProvider {
            static var previews: some View {
                DiscoverView()
            }
        }
