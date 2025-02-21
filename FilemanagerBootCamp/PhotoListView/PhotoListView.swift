//
//  PhotoListView.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import SwiftUI

struct PhotoListView: View {
    
    @StateObject var photoViewModel = PhotoListViewModel()
    
    var body: some View {
        NavigationStack {
            if photoViewModel.isLoading{
                ProgressView {
                    Text("Loading")
                        .font(.headline)
                }
            }else{
                List{
                    ForEach(photoViewModel.photoValues, id: \.id){ photo in
                        LazyVStack {
                            PhotoSelectionRow(photoData: photo)
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .navigationTitle("Photo Downloader")
            }
        }
    }
}

#Preview {
    PhotoListView()
}
