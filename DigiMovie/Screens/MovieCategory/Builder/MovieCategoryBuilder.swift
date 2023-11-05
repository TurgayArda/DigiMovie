//
//  MovieCategoryBuilder.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

final class MovieCategoryBuilder {
    static func make(id: Int,title: [String], movie: [String : [MovieListResult]]) -> MovieCategoryVC {
        let view = MovieCategoryVC()
        let interactor = MovieCategoryInteractor(id: id, titleList: title, movieList: movie)
        let presenter = MovieCategoryPresenter(interactor: interactor, view: view)
        view.interactor = interactor
        interactor.presenter = presenter
        return view
    }
}
