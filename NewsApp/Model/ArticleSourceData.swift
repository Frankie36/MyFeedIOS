//
//  ArticleSource.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 13/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import Foundation

public class ArticleSourceData{
    // MARK: - NewsSourceModel
    struct NewsSourceModel: Codable {
        let status: String
        let sources: [Source]
    }
    
    // MARK: - Source
    struct Source: Codable {
        let id, name, sourceDescription: String?
        let url: String
        let category: Category
        let language, country: String
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case sourceDescription = "description"
            case url, category, language, country
        }
    }
    
    enum Category: String, Codable {
        case business = "business"
        case entertainment = "entertainment"
        case general = "general"
        case health = "health"
        case science = "science"
        case sports = "sports"
        case technology = "technology"
    }

}
