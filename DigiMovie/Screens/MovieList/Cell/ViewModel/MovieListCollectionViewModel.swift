//
//  MovieListCollectionViewModel.swift
//  DigiMovie
//
//  Created by Arda Sisli on 3.11.2023.
//

import Foundation

protocol MovieListCollectionCellViewModelProtocol {
    func getItemName() -> String
    func getImageURL() -> String
}

class  MovieListCollectionCellViewModel: MovieListCollectionCellViewModelProtocol {
    var movieList: MovieListResult?
    
    init(movieList: MovieListResult) {
        self.movieList = movieList
    }
    
    func getItemName() -> String {
        guard let name = movieList?.originalTitle else {
            return MovieScreensConstant.MovieListConstant.unknown.rawValue
        }
        
        return name
    }
    
    func getImageURL() -> String {
        guard let poster = movieList?.posterPath  else {
            return ""
        }
        
        return MovieScreensConstant.MovieImage.movieURL(posterPath: poster)
    }
}
