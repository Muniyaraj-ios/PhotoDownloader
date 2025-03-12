//
//  PhotoLoadingViewModel.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import Foundation
import SwiftUI


class PhotoLoadingViewModel: ObservableObject{
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    let photoData: PhotoModel
    
    private let service: DownloadImageService
        
    private let photoCacheManager: ImageCacheService
    
    @MainActor
    init(service: DownloadImageService = DownloadImageManager(), photoCacheManager: ImageCacheService = PhotoModelCacheManager.instance, photoData: PhotoModel) {
        self.photoData = photoData
        self.service = service
        self.photoCacheManager = photoCacheManager
        self.getImageFromExisting()
    }
    
    @MainActor
    func getImageFromExisting(){
        Task(priority: .low){
            if let fileCacheImage = await photoCacheManager.get(key: photoData.id.description){
                print("photo feteched from cache...")
                image = fileCacheImage
            }else{
                await downloadImage()
            }
        }
    }
    
    @MainActor
    func downloadImage() async{
        isLoading = true
        Task(priority: .low){
            do{
                print("photo downloading started... : \(Task.currentPriority)")
                let returnedImage = try await service.downloadImage(from: photoData.src.small)
                if let returnedImage{
                    do{
                        try await photoCacheManager.add(key: photoData.id.description, value: returnedImage)
                    }catch let error{
                        print("got error get image : \(error)")
                    }
                }
                image = returnedImage
                isLoading = false
            }catch let error{
                isLoading = false
                if let error_asImage = error as? ImageDownloaderError{
                    switch error_asImage {
                    case .badURL:
                        print("download image catch error : Invalid URL")
                        break
                    case .badResponse(let statusCode):
                        print("download image catch error : Bad Status Code \(statusCode)")
                        break
                    case .invalidImageData:
                        print("download image catch error : Invalid Image data")
                        break
                    }
                }else{
                    print("download image catch error : \(error)")
                }
            }
        }
    }
}
