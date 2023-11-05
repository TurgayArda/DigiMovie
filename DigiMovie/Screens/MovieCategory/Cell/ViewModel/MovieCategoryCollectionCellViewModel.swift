//
//  MovieCategoryCollectionCellViewModel.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

protocol MovieCategoryCollectionCellViewModelProtocol {
    func getItemName() -> String
    func getImageURL() -> String
}

class  MovieCategoryCollectionCellViewModel: MovieCategoryCollectionCellViewModelProtocol {
    private var movieList: MovieListResult?
    
    init(movieList: MovieListResult) {
        self.movieList = movieList
    }
    
    func getItemName() -> String {
        guard let name = movieList?.originalTitle else {
            return MovieScreensConstant.MovieCategoryConstant.unknown.rawValue
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
