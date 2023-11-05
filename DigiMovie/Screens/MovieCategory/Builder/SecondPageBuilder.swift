//
//  SecondPageBuilder.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

final class SecondPageBuilder {
    static func make(viewModel: MovieCategoryViewModelProtocol) -> SecondPageVC {
        let view = SecondPageVC()
        view.categoryViewModel = viewModel
        return view
    }
}
