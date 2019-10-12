//
//  MovieListModel.swift
//  MoviesListingApp
//
//  Created by tanuj on 12/10/19.
//  Copyright © 2019 Tanuj Sharma. All rights reserved.
//

import Foundation

// MARK: - MoviesListModel
struct MoviesListModel: Codable {
    let search: [Search]
    let totalResults, response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}
