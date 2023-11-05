//
//  MovieListViewModel.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

protocol MovieListViewModelProtocol {
    func getMovieList() -> [String : [MovieListResult]]
    func getMovieImage() -> [String]
    func getGenreName() -> [String]
}

final class MovieListViewModel {
    private var movieList = [String : [MovieListResult]]()
    private var movieImage: [String] = []
    private var genreName: [String] = []
    
    init(movieList: [String : [MovieListResult]], movieImage: [String], genreName: [String]) {
        self.movieList = movieList
        self.movieImage = movieImage
        self.genreName = genreName
    }
}

extension MovieListViewModel: MovieListViewModelProtocol {
    func getMovieList() -> [String : [MovieListResult]] {
        movieList
    }
    
    func getMovieImage() -> [String] {
        movieImage
    }
    
    func getGenreName() -> [String] {
        genreName
    }
}
