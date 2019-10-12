//
//  ApiRequest.swift
//  MoviesListingApp
//
//  Created by tanuj on 12/10/19.
//  Copyright © 2019 Tanuj Sharma. All rights reserved.
//

import Foundation

class ApiRequest: NSObject
{
    struct ApiRequest {
        static let movieListUrl = "https://www.omdbapi.com/?apikey={{MovieApiKey}}&s={{SearchText}}&page={{PageNumber}}"
        static let movieApiKey = "d04c0097"
    }
    func fetchMoviesListForSearchText(using searchText: String, pageNumber : NSInteger , handler: @escaping(_ response: Data?, _ error: Error?) -> ()) {
        
        let apiKeyReplaceString: String = ApiRequest.movieListUrl.replacingOccurrences(of: "{{MovieApiKey}}", with: ApiRequest.movieApiKey, options: .literal, range: nil)
        var finalString: String = apiKeyReplaceString.replacingOccurrences(of: "{{SearchText}}", with: searchText, options: .literal, range: nil)
        finalString = finalString.replacingOccurrences(of: "{{PageNumber}}", with: String(pageNumber), options: .literal, range: nil)
        guard let baseUrl = URL(string: finalString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: baseUrl) { (data, reposne, error) in
            if let error = error {
                handler(nil, error)
                return
            }
            if let data = data {
                handler(data, nil)
            }
        }
        task.resume()
    }
}
