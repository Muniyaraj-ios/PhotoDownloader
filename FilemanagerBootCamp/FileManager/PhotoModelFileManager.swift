//
//  PhotoModelFileManager.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import Foundation
import SwiftUI

actor PhotoModelFileManager: ImageFileCacheService{
    
    static let instance = PhotoModelFileManager()
    private let folder_name = "downloaded_photos"
    
    private var isMemoryCache = NSCache<NSString, UIImage>()
        
    private init(){
        Task{
            await createFolderIfneeded()
        }
    }
    
    private func createFolderIfneeded(){
        guard let url = getFolderPath() else{ return }
        guard !FileManager.default.fileExists(atPath: url.path) else{
            print("\(folder_name) already exists")
            return
        }
        do{
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            print("\(folder_name) Folder Created")
        }catch let error{
            print("Error creating on file : \(error)")
        }
    }
    
    nonisolated private func getFolderPath() -> URL?{
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(folder_name)
    }
    
    nonisolated private func getImagePath(key: String)-> URL?{
        guard let folder = getFolderPath() else{ return nil }
        return folder.appending(components: key+".png", directoryHint: .isDirectory)
    }
}

extension PhotoModelFileManager{
    
    func add(key: String, value: UIImage) async {
        
        // save in cache
        isMemoryCache.setObject(value, forKey: key as NSString)
        
        // save in disk
        guard let data = value.pngData(), let url = getImagePath(key: key) else{ return }
        
        do{
            try data.write(to: url)
        }catch let error{
            print("❌ Error saving on image : \(error)")
        }
    }
    
    func get(key: String) async -> UIImage? {
        if let imageCache = isMemoryCache.object(forKey: key as NSString){
            return imageCache
        }
        guard let url = getImagePath(key: key), FileManager.default.fileExists(atPath: url.path) else{ return nil }
        if let image = UIImage(contentsOfFile: url.path(percentEncoded: true)){ // for save memory cache for faster
            isMemoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        return nil
    }
    
    func remove(with key: String) async {
        guard let url = getImagePath(key: key), FileManager.default.fileExists(atPath: url.path) else{ return }
        
        do{
            try FileManager.default.removeItem(at: url)
            print("✅ removed an image from cache")
        }catch let error{
            print("❌ Error removing on image : \(error)")
        }
    }
    
    func clearAllCache() async {
        guard let directoryPath = getFolderPath(), FileManager.default.fileExists(atPath: directoryPath.path) else{ return }
        
        do{
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: directoryPath.path)
            for filePath in filePaths{
                let fullPath = directoryPath.appending(component: filePath)
                try FileManager.default.removeItem(at: fullPath)
            }
        }catch let error{
            print("❌ Error removing on images : \(error)")
        }
    }
}
