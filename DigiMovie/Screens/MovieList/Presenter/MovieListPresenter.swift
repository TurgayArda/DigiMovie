//
//  MovieListPresenter.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import Foundation

protocol MovieListPresenterProtocol {
    func handleOutPut(_ output: MovieListInteractorOutPut)
    func movieInfoData(image: [String], title: [String], movieList: [String : [MovieListResult]])
    func movieError(error: String)
    func isLoading(isLoading: Bool)
}

enum MovieListPresenterOutPut {
    case error(String)
    
}

enum MoviePresenterOutPut {
    case movieList(MovieListViewModel)
    case error(String)
    case isLoading(Bool)
}

class MovieListPresenter: MovieListPresenterProtocol {
    var interactor: MovieListInteractorProtocol?
    let view: MovieListViewDelegate?
    
    init(interactor: MovieListInteractorProtocol,
         view: MovieListViewDelegate
    ){
        self.interactor = interactor
        self.view = view
    }
}

extension MovieListPresenter {
    func movieInfoData(image: [String], title: [String], movieList: [String : [MovieListResult]]) {
        let viewModel = MovieListViewModel(movieList: movieList, movieImage: image, genreName: title)
        view?.movieHandleOutPut(.movieList(viewModel))
    }
    
    func movieError(error: String) {
        view?.movieHandleOutPut(.error(error))
    }
    
    func isLoading(isLoading: Bool) {
        view?.movieHandleOutPut(.isLoading(isLoading))
    }
    
    func handleOutPut(_ output: MovieListInteractorOutPut) {
        switch output {
        case .error(let error):
            view?.handleOutPut(.error(error))
        }
    }
}
