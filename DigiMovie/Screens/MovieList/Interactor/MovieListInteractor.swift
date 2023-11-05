//
//  MovieListInteractor.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import Foundation

protocol MovieListInteractorProtocol {
    var presenter: MovieListPresenterProtocol? { get set }
    func fechMovieGenre()
    func fetchMovie(genreID: String)
}

enum MovieListInteractorOutPut {
    case error(String)
}

class MovieListInteractor: MovieListInteractorProtocol {
    var presenter: MovieListPresenterProtocol?
    let service: HttpClientProtocol?
    var genreList: [Genre] = []
    var genreName: [String] = []
    var movieImage: [String] = []
    var movieListData = [String : [MovieListResult]]()
    var genreIndex = 0
    
    init(service: HttpClientProtocol) {
        self.service = service
    }
}

extension MovieListInteractor {
    func fechMovieGenre() {
        guard let url = URL(string: NetworkConstant.MovieListGenreNetwork.movieListGenreURL()) else { return }
        service?.fetchData(url: url, completion: { [presenter] (result: Result<GenreResult, Error>) in
            switch result {
            case .success(let success):
                guard let movieGenre = success.genres else {
                    presenter?.handleOutPut(.error("Error"))
                    return
                }
                
                self.genreIndex = 0
                self.genreList = movieGenre
                self.movieGenreList()
                
            case .failure(let failure):
                presenter?.handleOutPut(.error(failure.localizedDescription))
            }
        })
    }
    
    func fetchMovie(genreID: String) {
        guard let url = URL(string: NetworkConstant.MovieListNetwork.movieListURL(genre: genreID)) else { return }
        service?.fetchData(url: url, completion: { [presenter] (result: Result<MovieList, Error>) in
            switch result {
            case .success(let success):
                guard let movieList = success.results else {
                    presenter?.movieError(error: "error")
                    return
                }
                
                if self.genreIndex == 0 {
                    for i in movieList {
                        self.movieImage.append(i.posterPath ?? "")
                    }
                }
                
                self.setMovieList(movieList: movieList, index: self.genreIndex)
                presenter?.isLoading(isLoading: true)
                self.fetchMovieData()
                
                
            case .failure(let failure):
                presenter?.movieError(error: failure.localizedDescription)
            }
        })
    }
}

extension MovieListInteractor {
    private func setMovieList(movieList: [MovieListResult], index: Int) {
        self.movieListData[self.genreList[index].name ?? ""] = movieList
    }
    
    func movieGenreList() {
        for i in genreList {
            genreName.append(i.name ?? "")
        }
        self.fetchMovie(genreID: String(genreList[genreIndex].id ?? 0))
    }
    
    func fetchMovieData() {
        genreIndex += 1
        
        if genreIndex < genreList.count {
            self.fetchMovie(genreID: String(genreList[genreIndex].id ?? 0))
        }else{
            presenter?.isLoading(isLoading: false)
            presenter?.movieInfoData(image: movieImage, title: genreName, movieList: movieListData)
        }
    }
}
