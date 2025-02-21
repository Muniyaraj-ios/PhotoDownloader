//
//  PhotoModelCacheManager.swift
//  FilemanagerBootCamp
//
//  Created by MAC on 19/02/25.
//

import Foundation
import SwiftUI

actor PhotoModelCacheManager: ImageCacheService{
    
    static let instance = PhotoModelCacheManager()
    
    private var photoCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200
        return cache
    }()
    
    private init(){}
    
    func add(key: String, value: UIImage) async{
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) async -> UIImage? {
        return photoCache.object(forKey: key as NSString)
    }
    
    func remove(with key: String) async {
        photoCache.removeObject(forKey: key as NSString)
    }
    
    func clearAllCache() async{
        photoCache.removeAllObjects()
    }
}


protocol ImageCacheService{
    func add(key: String, value: UIImage) async
    func get(key: String) async -> UIImage?
    
    func remove(with key: String) async
    func clearAllCache() async
}

protocol ImageFileCacheService: ImageCacheService{
    
}
