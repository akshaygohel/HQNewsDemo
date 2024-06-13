//
//  HQBookmarkPersistence.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

class HQBookmarkPersistence {
    
    static let shared = HQBookmarkPersistence()
    
    private let persistence: PreferencesPersisting = UserDefaults.standard
    private let persistenceKey: String = "BookmarksPersistence"
    
    private init() { }
    
    func isBookmarked(url: String) -> Bool {
        let array = self.persistence.stringArray(forKey: self.persistenceKey) ?? [String]()

        if array.firstIndex(of: url) != nil {
            return true
        }

        return false
    }
    
    func addBookmark(url: String) {
        var array = self.persistence.stringArray(forKey: self.persistenceKey) ?? [String]()
        
        if array.firstIndex(of: url) == nil {
            array.append(url)
        }
        
        self.persistence.set(array, forKey: self.persistenceKey)
    }
    
    func removeBookmark(url: String) {
        var array = self.persistence.stringArray(forKey: self.persistenceKey) ?? [String]()

        if let index = array.firstIndex(of: url) {
            array.remove(at: index)
        }
        
        self.persistence.set(array, forKey: self.persistenceKey)
    }
    
}
