//
//  ThirdPageBuilder.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import Foundation

final class ThirdPageBuilder {
    static func make(viewModel: MovieCategoryViewModelProtocol) -> ThirdPageVC {
        let view = ThirdPageVC()
        view.categoryViewModel = viewModel
        return view
    }
}
