    //
    //  DiscoverView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct DiscoverView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var discoverResults: FetchedResults<DiscoverMedia>

    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(discoverResults) { media in
                        NavigationLink {
                            DiscoverMovieView(media: media)
                        } label: {
                            VStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(media.wrappedPosterPath)")) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image("poster_placeholder")
                                        .resizable()
                                        .scaledToFit()
                                        .overlay(Color.black.opacity(0.8))
                                }
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                
                                Text(media.wrappedTitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 10)
                                Text(media.wrappedReleaseDate)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Discover")
            .task {
                await loadDiscovery()
            }
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

    }


    func loadDiscovery() async {

        for object in discoverResults {
                moc.delete(object)
        }

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
                }
            }
        } catch {
            print("Invalid Data")
        }
    }


    func DiscoverItem(item: DiscoverResult) {
        let newItem = DiscoverMedia(context: moc)
        newItem.title = item.title ?? "Unknown"
        newItem.id = Int32(item.id)
        newItem.backdrop_path = item.backdrop_path
        newItem.poster_path = item.poster_path
        newItem.media_type = "movie"
        newItem.original_language = item.original_language
        newItem.original_title = item.original_title
        newItem.overview = item.overview
        newItem.release_date = item.release_date

        if let date = item.release_date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsed = formatter.date(from: date) {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: parsed)
                newItem.release_date = "\(year)"
            }
        }

                    //        newItem.genre_ids = item.genre_ids

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
