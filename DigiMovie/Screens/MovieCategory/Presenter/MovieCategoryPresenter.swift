//
//  MovieCategoryPresenter.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

protocol MovieCategoryPresenterProtocol {
    func movieCategoryInfo(title: [String], movieList: [String : [MovieListResult]], segmentID: Int)
}

enum MovieCategoryPresenterOutPut {
    case categoryInfo(MovieCategoryViewModel)
}

class MovieCategoryPresenter: MovieCategoryPresenterProtocol {
    var interactor: MovieCategoryInteractorProtocol?
    let view: MovieCategoryViewDelegate?
    
    init(interactor: MovieCategoryInteractorProtocol,
         view: MovieCategoryViewDelegate
    ){
        self.interactor = interactor
        self.view = view
    }
}

extension MovieCategoryPresenter {
    func movieCategoryInfo(title: [String], movieList: [String : [MovieListResult]], segmentID: Int) {
        let viewModel = MovieCategoryViewModel(movieList: movieList, segmentID: segmentID, genreName: title)
        view?.handleOutPut(.categoryInfo(viewModel))
    }
}
