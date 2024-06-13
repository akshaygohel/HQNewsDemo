//
//  HQWebServiceProtocol.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

protocol HQWebServiceProtocol {
    func getData<T: Decodable>(urlString: String, _ completion: @escaping (_ success: Bool, _ model: T?, _ error: HQWebServiceError?) -> ())
}

extension HQWebServiceProtocol {
    func getData<T: Decodable>(urlString: String, _ completion: @escaping (_ success: Bool, _ model: T?, _ error: HQWebServiceError?) -> ()) {}
}
