//
//  MovieCategoryinteractor.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

protocol MovieCategoryInteractorProtocol {
    var presenter: MovieCategoryPresenterProtocol? { get set }
    func fetchMovie()
}

class MovieCategoryInteractor {
    var id: Int?
    var titleList: [String] = []
    var movieList = [String : [MovieListResult]]()
    var presenter: MovieCategoryPresenterProtocol?
    
    init(id: Int,
         titleList: [String],
         movieList: [String : [MovieListResult]]
    ){
        self.id = id
        self.movieList = movieList
        self.titleList = titleList
    }
}

extension MovieCategoryInteractor: MovieCategoryInteractorProtocol {
    func fetchMovie() {
        guard let segmentID = id else { return }
        presenter?.movieCategoryInfo(title: titleList, movieList: movieList, segmentID: segmentID)
    }
}
