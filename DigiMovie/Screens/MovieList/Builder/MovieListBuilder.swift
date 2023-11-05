//
//  MovieListBuilder.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import Foundation

final class MovieListBuilder {
    static func make() -> MovieListVC {
        let view = MovieListVC()
        let client = HttpClient(client: URLSession.shared)
        let interactor = MovieListInteractor(service: client)
        let presenter = MovieListPresenter(interactor: interactor, view: view)
        let router = MovieListRouter(view: view)
        interactor.presenter = presenter
        view.interactor = interactor
        view.router = router
        return view
    }
}
