//
//  PhotoListViewModel.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import Foundation


class PhotoListViewModel: ObservableObject{
    
    let service: NetworkService
    
    @Published public var isLoading: Bool = false
    @Published public var photoValues: [PhotoModel] = []
    
    @MainActor
    init(service: NetworkService = .default) {
        self.service = service
        getPhotoLists()
    }
    
    @MainActor
    func getPhotoLists(){
        isLoading = true
        Task(priority: .low){
            let photo_url = "https://raw.githubusercontent.com/Muniyaraj-ios/assets/main/Photos/products.json"
            do{
                let photo_response: PhotoResponseModel = try await service.performRequest(urlString: photo_url)
                isLoading = false
                photoValues = photo_response.photos
            }catch let error{
                print("get catched error in photolist : \(error)")
                isLoading = false
            }
        }
    }
    
}
