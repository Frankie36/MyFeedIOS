//
//  Article.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 13/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import Foundation
public class ArticleData{
    // MARK: - NewsResponse
    struct NewsResponse: Codable {
        let status: String
        let totalResults: Int?
        let articles: [Article]?
    }
    
    // MARK: - Article
    struct Article: Codable {
        let source: Source
        let author: String?
        let title, articleDescription: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String
        let content: String?
        
        enum CodingKeys: String, CodingKey {
            case source, author, title
            case articleDescription = "description"
            case url, urlToImage, publishedAt, content
        }
    }
    
    // MARK: - Source
    struct Source: Codable {
        let id: String?
        let name: String
    }
    
}

