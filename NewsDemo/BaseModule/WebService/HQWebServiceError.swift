//
//  HQWebServiceError.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

enum HQWebServiceError {
    case networkError
    case internalError
    case customError(message: String)
    
    var rawValue: String {
        switch self {
        case .networkError: return "Seems you are not connected to internet."
        case .internalError: return "Something went wrong. Please try again later."
        case .customError(let message): return message
        }
    }
}
