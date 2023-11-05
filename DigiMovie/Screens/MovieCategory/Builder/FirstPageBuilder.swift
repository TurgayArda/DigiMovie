//
//  FirstPageBuilder.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

final class FirstPageBuilder {
    static func make(viewModel: MovieCategoryViewModelProtocol) -> FirstPageVC {
        let view = FirstPageVC()
        view.categoryViewModel = viewModel
        return view
    }
}
