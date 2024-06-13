//
//  HQNewsArticles.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

struct HQNewsArticles: Decodable {
    let status: String?
    let totalResults: Int?
    private let newsArticles: [HQNewsArticle]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case newsArticles = "articles"
    }
    
    func articles() -> [HQNewsArticle]? {
        return self.newsArticles
    }
}

struct HQNewsArticle: Decodable {
    public let source: HQNewsSource?
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
}

struct HQNewsSource: Decodable {
    let identifier: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name = "name"
    }
}
