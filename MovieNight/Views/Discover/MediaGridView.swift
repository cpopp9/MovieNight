    //
    //  MediaGridView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 3/1/23.
    //

import CoreData
import SwiftUI

struct MediaGridView: View {
    
    @FetchRequest var mediaArray: FetchedResults<Media>
    
    @Environment(\.managedObjectContext) var moc
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 10, alignment: .topTrailing)]
    
    @Binding var endOfList: Bool
    
    var body: some View {
        
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
    
    
    init(mediaGridType: MediaGridType, endOfList: Binding<Bool>) {
    
        if mediaGridType == .discover {
            _mediaArray = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.timeAdded, order: .forward)], predicate: NSPredicate(format: "isDiscoverObject == true"))
        } else {
            _mediaArray = FetchRequest<Media>(sortDescriptors: [SortDescriptor(\.timeAdded, order: .forward)])
        }

        self._endOfList = endOfList
    }

}

struct MediaGridView_Previews: PreviewProvider {
    static var previews: some View {
        MediaGridView(mediaGridType: .discover, endOfList: .constant(true))
    }
}

enum MediaGridType {
    case discover, search
}
