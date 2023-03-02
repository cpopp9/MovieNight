//
//  MediaGridView.swift
//  MovieNight
//
//  Created by Cory Popp on 3/1/23.
//

import SwiftUI

struct MediaGridView: View {
    
    @FetchRequest var mediaArray: FetchedResults<Media>
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    @Binding var endOfList: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("New and upcoming releases:")
            
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns) {
                ForEach(mediaArray) { media in
                    PosterView(media: media)
                }
                
                Image(systemName: "plus")
                    .opacity(0)
                    .onAppear {
                        endOfList.toggle()
                    }
            }
            .padding(.horizontal)
        }
    }
    
    init(endOfList: Binding<Bool>) {
        _mediaArray = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.timeAdded, order: .forward)], predicate: NSPredicate(format: "isDiscoverObject == true"))
        self._endOfList = endOfList
    }
    
}

struct MediaGridView_Previews: PreviewProvider {
    static var previews: some View {
        MediaGridView(endOfList: .constant(true))
    }
}
