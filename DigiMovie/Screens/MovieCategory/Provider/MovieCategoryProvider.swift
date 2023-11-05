//
//  MovieCategoryProvider.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import UIKit

protocol MovieCategoryCollectionProviderProtocol {
    var delegate: MovieCategoryCollectionProviderDelegate? { get set }
    func load(value: [MovieListResult])
    func loadTitle(value: [String])
}

protocol MovieCategoryCollectionProviderDelegate {
    func getWidth() -> CGFloat
    func videoTapped(url: URL, title: String)
}

class MovieCategoryCollectionProvider: NSObject {
    
    var delegate: MovieCategoryCollectionProviderDelegate?
    var listItem: [MovieListResult] = []
    var listTitle: [String] = []
}

//MARK: - HomePageListProviderProtocol

extension MovieCategoryCollectionProvider: MovieCategoryCollectionProviderProtocol {
    func load(value: [MovieListResult]) {
        self.listItem = value
    }
    
    func loadTitle(value: [String]) {
        self.listTitle = value
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MovieCategoryCollectionProvider: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCategoryCollectionViewCell.Identifier.path.rawValue, for: indexPath) as? MovieCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = MovieCategoryCollectionCellViewModel(movieList: listItem[indexPath.row])
        cell.saveModel(viewModel: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let with = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let width = (with) / 3.2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: MovieScreensConstant.videoURL.videoURL.rawValue) {
            if let titleData = listItem[indexPath.row].originalTitle {
                delegate?.videoTapped(url: url, title: titleData)
            }else{
                delegate?.videoTapped(url: url, title: MovieScreensConstant.MovieCategoryConstant.unknown.rawValue)
            }
        }
    }
}
