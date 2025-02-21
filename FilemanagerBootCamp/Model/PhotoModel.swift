//
//  PhotoModel.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import Foundation

struct PhotoResponseModel: Codable{
    let photos: [PhotoModel]
}

struct PhotoModel: Codable{
    let id: Int
    let photographer: String
    let photographer_url: String?
    let alt: String
    let src: SRCPhotoModel
}

struct SRCPhotoModel: Codable{
    let original: String
    let small: String
}
