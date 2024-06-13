//
//  HQPrefencesPersistence.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

/// Something capable of persisting values for a given key.
public protocol PreferencesPersisting {
    func value(forKey defaultName: String) -> Any?
    func array(forKey defaultName: String) -> [Any]?
    func stringArray(forKey defaultName: String) -> [String]?
    func bool(forKey defaultName: String) -> Bool
    func string(forKey defaultName: String) -> String?
    func integer(forKey defaultName: String) -> Int
    func hasValue(forKey defaultName: String) -> Bool
    
    func set(_ value: Any?, forKey defaultName: String)
    func set(_ value: Bool, forKey defaultName: String)
    func set(_ value: Int, forKey defaultName: String)
    
    @discardableResult func synchronize() -> Bool
}

extension UserDefaults: PreferencesPersisting {
    public func hasValue(forKey key: String) -> Bool {
        return nil != object(forKey: key)
    }
}
