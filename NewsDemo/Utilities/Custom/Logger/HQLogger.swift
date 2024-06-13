//
//  HQLogger.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
#endif
}
