//
//  NetworkManager.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import Foundation
import SwiftUI

class NetworkManager: NetworkService{
    
    func performRequest<T: Codable>(urlString: String) async throws -> T{
        guard let urlRequest = URL(string: urlString) else{ throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: urlRequest)
        
        guard let httpsresponse = response as? HTTPURLResponse, (200...299).contains(httpsresponse.statusCode) else{ throw URLError(.badServerResponse) }
        
        let decoded_Data = try decoder.decode(T.self, from: data)
        
        return decoded_Data
    }
    
    private var decoder: JSONDecoder{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

protocol NetworkService{
    func performRequest<T: Codable>(urlString: String) async throws -> T
}

extension NetworkService where Self == NetworkManager{
    static var `default`: Self{ NetworkManager() }
}

protocol DownloadImageService{
    func downloadImage(from urlString: String) async throws -> UIImage?
}


class DownloadImageManager: DownloadImageService{
    
    func downloadImage(from urlString: String) async throws -> UIImage? {
        guard let urlrequest = URL(string: urlString) else{ throw ImageDownloaderError.badURL }
        
        let (data, response) = try await URLSession.shared.data(from: urlrequest)
        
        if let https_response = response as? HTTPURLResponse, !(200...299).contains(https_response.statusCode){
            throw ImageDownloaderError.badResponse(statusCode: https_response.statusCode)
        }
        
        guard let image = UIImage(data: data) else{ throw ImageDownloaderError.invalidImageData }
        
        return image
    }
}

enum ImageDownloaderError: Error{
    case badURL
    case badResponse(statusCode: Int)
    case invalidImageData
}
