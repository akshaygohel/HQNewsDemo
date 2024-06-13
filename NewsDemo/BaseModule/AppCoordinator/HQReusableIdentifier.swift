//
//  HQReuseIdentifiable.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

public protocol HQReuseIdentifiable {
    /// An identifier used to store a class for reuse
    static var reuseIdentifier: String { get }
}

extension HQReuseIdentifiable where Self: UIView {
    /// The reuse identifier of a view defaults to that view's String(describing: self)
    public static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableViewCell: HQReuseIdentifiable { }

extension UITableViewHeaderFooterView: HQReuseIdentifiable { }

extension UICollectionReusableView: HQReuseIdentifiable { }
