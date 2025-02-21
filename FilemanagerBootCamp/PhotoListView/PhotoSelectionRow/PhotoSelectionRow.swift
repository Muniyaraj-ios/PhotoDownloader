//
//  PhotoSelectionRow.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import SwiftUI

struct PhotoSelectionRow: View {
    
    let photoData: PhotoModel
    
    var body: some View {
        HStack(alignment: .center) {
            PhotoDisplayView(photoData: photoData)
                .frame(width: 75, height: 75)
            VStack(alignment: .leading, spacing: 4) {
                Text(photoData.photographer)
                    .font(.headline)
                Text(photoData.alt)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
        }
    }
}
