//
//  MovieGenre.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import Foundation

// MARK: - Temperatures

struct GenreResult: Codable {
    let genres: [Genre]?
}

// MARK: - Genre

struct Genre: Codable {
    let id: Int?
    let name: String?
}
