//
//  NewsData.swift
//  COVID-19 Tracker
//
//  Created by SCG on 6/6/20.
//  Copyright © 2020 SCG. All rights reserved.
//

import Foundation

//MARK: - Displayable Protocol

protocol Displayable {
    var titleLabelText: String { get }
    var subtitleLabelText: String { get }
    var website: String { get }
}

//MARK: - Article

struct Article: Decodable {
    let title: String
    let description: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case url
    }
}

extension Article: Displayable {
    var titleLabelText: String {
        title
    }
    
    var subtitleLabelText: String {
        description
    }
    
    var website: String {
        url
    }
    
}

//MARK: - Results

struct Articles: Decodable {
    let totalResults: Int
    let all: [Article]
    
    enum CodingKeys: String, CodingKey {
        case totalResults
        case all = "articles"
    }
}
