//
//  PhotoDisplayView.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import SwiftUI

struct PhotoDisplayView: View {
    
    @StateObject var photoLoader: PhotoLoadingViewModel
    
    init(photoData: PhotoModel) {
        _photoLoader = StateObject(wrappedValue: PhotoLoadingViewModel(photoData: photoData))
    }
    
    var body: some View {
        ZStack {
            if photoLoader.isLoading{
                ProgressView()
            }else if let image = photoLoader.image{
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}
