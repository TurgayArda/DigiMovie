//
//  UIConstant.swift
//  DigiMovie
//
//  Created by Arda Sisli on 3.11.2023.
//

import Foundation

final class MovieScreensConstant {
    enum MovieImage: String {
        case path_url = "https://image.tmdb.org/t/p/w185"
        
        static func movieURL(posterPath: String) -> String {
            return "\(path_url.rawValue)\(posterPath)"
        }
    }
    
    enum videoURL: String {
        case videoURL = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
    }
    
    enum MovieListConstant: String {
        case unknown = "Unknown"
        case title = "FILM"
        case foreignButton = "Yabanci Film"
        case domesticButton = "Yerli Film"
        case depictionButton = "Betimleme"
    }
    
    enum MovieCategoryConstant: String {
        case segmentOne = "Yabanci Film"
        case segmentSecond = "Yerli Film"
        case segmentThird = "Betimleme"
        case title = "FILM"
        case unknown = "Unknown"
    }
}
