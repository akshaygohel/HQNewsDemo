//
//  UITableViewExtensions.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

public extension UITableView {
    
    //MARK: Registration
    /**
     Registers a cell for use with a table view.
     - Parameter type: The type of the cell being registered.
     */
    func register<T: UITableViewCell>(type: T.Type) {
        register(type, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a nib for use with a table view.
     - Parameter type: The class of the nib being registered. This should match its reuse identifier.
     */
    func registerNib<T: UITableViewCell>(for type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
}
