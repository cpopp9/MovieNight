    //
    //  DiscoverView.swift
    //  MovieNight
    //
    //  Created by Cory Popp on 9/29/22.
    //

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var discoverVM = DiscoverViewModel()
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var endOFList = false
    
    var body: some View {
        ScrollView {
            VStack {
                MediaGridView(mediaGridType: .discover, endOfList: $endOFList)
                    .onChange(of: endOFList, perform: { _ in
                        Task {
                            await discoverVM.downloadDiscoveryMedia(context: moc)
                        }
                    })
            }
        }
        .navigationTitle("Discover")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu() {
                        Button() {
                            discoverVM.selectedRange = .current
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("Current")
                        }
                        Button() {
                            discoverVM.selectedRange = .twentyTens
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("2010's")
                        }
                        Button() {
                            discoverVM.selectedRange = .twoThousands
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("2000's")
                        }
                        Button() {
                            discoverVM.selectedRange = .nineties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("90's")
                        }
                        Button() {
                            discoverVM.selectedRange = .eighties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("80's")
                        }
                        Button() {
                            discoverVM.selectedRange = .seventies
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("70's")
                        }
                        Button() {
                            discoverVM.selectedRange = .sixties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("60's")
                        }
                        Button() {
                            discoverVM.selectedRange = .fifties
                            discoverVM.deleteObjects(filter: .discover, context: moc)
                            discoverVM.pageCount = 1
                        } label: {
                            Text("50's")
                        }
                } label: {
                    Image(systemName: "calendar")
                }
            }
        }
    }
    
    func download() {
        Task {
            await discoverVM.downloadDiscoveryMedia(context: moc)
        }
    }
    
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
