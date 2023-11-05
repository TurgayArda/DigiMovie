//
//  NetworkConstant.swift
//  DigiMovie
//
//  Created by Arda Sisli on 3.11.2023.
//

import Foundation

final class NetworkConstant {
    
    enum MovieListGenreNetwork: String {
        case path_url = "https://api.themoviedb.org/3"
        case genre_url = "/genre/movie/list"
        case api_key = "?api_key=3bb3e67969473d0cb4a48a0dd61af747"
        case language_url = "&language=en-US"
        
        static func movieListGenreURL() -> String {
            return "\(path_url.rawValue)\(genre_url.rawValue)\(api_key.rawValue)\(language_url.rawValue)"
        }
    }
    
    enum MovieListNetwork: String {
        case path_url = "https://api.themoviedb.org/3"
        case movie_url = "/discover/movie"
        case api_key = "?api_key=3bb3e67969473d0cb4a48a0dd61af747"
        case sort_url = "&sort_by=popularity.desc"
        case adult_url = "&include_adult=false"
        case video_url = "&include_video=false"
        case page_url = "&page=1"
        case genreID_url = "&with_genres="
        
        static func movieListURL(genre: String) -> String {
            return "\(path_url.rawValue)\(movie_url.rawValue)\(api_key.rawValue)\(sort_url.rawValue)\(adult_url.rawValue)\(video_url.rawValue)\(page_url.rawValue)\(genreID_url.rawValue)\(genre)"
        }
    }
}
