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
    
    init(service: NetworkService = NetworkManager()) {
        self.service = service
        Task.detached(priority: .background, operation: { [weak self] in
            await self?.getPhotoLists()
        })
    }
    
    @MainActor
    func getPhotoLists() async{
        isLoading = true
        Task{
            let photo_url = "https://run.mocky.io/v3/d5914d43-266d-4aa7-acc3-305154cbe0a3"
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
