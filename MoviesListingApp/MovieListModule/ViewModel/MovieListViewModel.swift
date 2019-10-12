//
//  MovieListViewModel.swift
//  MoviesListingApp
//
//  Created by tanuj on 12/10/19.
//  Copyright © 2019 Tanuj Sharma. All rights reserved.
//

import Foundation

class MovieListViewModel: NSObject {
    
    func apiCallForMoviesList(using searchText: String, pageNumber : NSInteger ,handler: @escaping(MoviesListModel) -> ())
    {
        ApiRequest().fetchMoviesListForSearchText(using: searchText, pageNumber: pageNumber, handler: {(data, error) in
            guard let data = data else {
                return
            }
            do {
                let moviesListModel = try JSONDecoder().decode(MoviesListModel.self, from: data)
                handler(moviesListModel)
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
}
