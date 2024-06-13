//
//  HQHomeWebService.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

protocol HQHomeWebServiceProtocol {
    func getNewsArticlesData(_ completion: @escaping (_ success: Bool, _ model: HQNewsArticles?, _ error: HQWebServiceError?) -> ())
}

class HQHomeWebService: HQHomeWebServiceProtocol {
    let webService: HQWebServiceProtocol = HQWebService()
    
    func getNewsArticlesData(_ completion: @escaping (_ success: Bool, _ model: HQNewsArticles?, _ error: HQWebServiceError?) -> ()) {
        /// TODO:
        /// 1. Put the code for base url into separate file.
        /// 2. Place this key to a better place and obfuscate it.
        let urlString = "https://newsapi.org/v2/top-headlines?country=in&apiKey=9246cd5c5ee0484981bd0589b2152372"
        self.webService.getData(urlString: urlString, completion)
    }
}
