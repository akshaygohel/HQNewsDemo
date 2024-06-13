//
//  UIStoryboardExtensions.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

//MARK: Storyboard Identifiable
public protocol StoryboardIdentifiable {
    /// An identifier used to store the storyboard containing this class
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
    /// The storyboard identifier of a view controller defaults to that view controller's String(describing: self)
    public static var storyboardIdentifier: String { return String(describing: self) }
}

public extension UIStoryboard {
    
    /// A small struct used to represent the name and bundle of a storyboad object.
    struct Identifier {
        public let name: String
        public let bundle: Bundle
        
        /**
         Identifying information for storyboards
         - Parameter name: The name of the storyboard.
         - Parameter bundle: The bundle of the storyboard.
         */
        public init(name: String, bundle: Bundle = Bundle.main) {
            self.name = name
            self.bundle = bundle
        }
    }
    
    /**
     Convenience initializer for storyboards
     - Parameter identifier: The name and bundle of a storyboard.
    */
    convenience init(identifier: UIStoryboard.Identifier) {
        self.init(name: identifier.name, bundle: identifier.bundle)
    }
    
    /**
     Returns the initial view controller of type T.
     - Returns: A view controller of type T.
    */
    func instantiateInitialViewController<T: UIViewController>() -> T {
        guard let vc = instantiateInitialViewController() as? T else {
            fatalError("Unable to instantiate the initial view controller as \(T.self) from storyboard \(self)")
        }
        
        return vc
    }
    
    /**
     Returns a view controller of type T.
     - Returns: A view controller of type T.
    */
    func instantiateViewController<T: UIViewController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Unable to instantiate a view controller with identifier \(T.storyboardIdentifier) from storyboard \(self)")
        }
        
        return vc
    }
}
