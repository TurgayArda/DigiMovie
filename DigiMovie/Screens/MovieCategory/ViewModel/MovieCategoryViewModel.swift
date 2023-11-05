//
//  MovieCategoryViewModel.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

protocol MovieCategoryViewModelProtocol {
    func getMovieList() -> [String : [MovieListResult]]
    func getSegmentID() -> Int
    func getGenreName() -> [String]
    func reverseGenreName() -> [String]
    func reverseDictionary() -> [String: [MovieListResult]]
}

final class MovieCategoryViewModel {
    private var movieList = [String : [MovieListResult]]()
    private var segmentID: Int?
    private var genreName: [String] = []
    
    init(movieList: [String : [MovieListResult]], segmentID: Int, genreName: [String]) {
        self.movieList = movieList
        self.segmentID = segmentID
        self.genreName = genreName
    }
}

extension MovieCategoryViewModel: MovieCategoryViewModelProtocol {
    func getMovieList() -> [String : [MovieListResult]] {
        movieList
    }
    
    func getSegmentID() -> Int {
        segmentID ?? 0
    }
    
    func getGenreName() -> [String] {
        genreName
    }
    
    func reverseGenreName() -> [String] {
        genreName.reversed()
    }
    
    func reverseDictionary() -> [String: [MovieListResult]] {
        var reversedDictionary = [String: [MovieListResult]]()
        
        for (key, value) in movieList {
            reversedDictionary[key] = value.reversed()
        }
        
        return reversedDictionary
    }
}
