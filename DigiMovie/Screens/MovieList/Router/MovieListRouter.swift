//
//  MovieListRouter.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import UIKit

protocol MovieListRouterProtocol {
    func navigate(id: Int, title: [String], MovieList: [String : [MovieListResult]])
}

class MovieListRouter: MovieListRouterProtocol {
    let view: UIViewController
    
    init( view: UIViewController) {
        self.view = view
    }
    
    func navigate(id: Int, title: [String], MovieList: [String : [MovieListResult]]) {
        let vc = MovieCategoryBuilder.make(id: id, title: title, movie: MovieList)
        vc.modalPresentationStyle = .fullScreen
        view.present(vc, animated: true)
    }
}
