//
//  MovieListProvider.swift
//  DigiMovie
//
//  Created by Arda Sisli on 3.11.2023.
//

import UIKit

protocol MovieListCollectionProviderProtocol {
    var delegate: MovieListCollectionProviderDelegate? { get set }
    func load(value: [MovieListResult])
    func loadTitle(value: [String])
}

protocol MovieListCollectionProviderDelegate {
    func getWidth() -> CGFloat
    func videoTapped(url: URL, title: String)
}

class MovieListCollectionProvider: NSObject {
    
    var delegate: MovieListCollectionProviderDelegate?
    var listItem: [MovieListResult] = []
    var listTitle: [String] = []
}

//MARK: - HomePageListProviderProtocol

extension MovieListCollectionProvider: MovieListCollectionProviderProtocol {
    func load(value: [MovieListResult]) {
        self.listItem = value
    }
    
    func loadTitle(value: [String]) {
        self.listTitle = value
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MovieListCollectionProvider: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.Identifier.path.rawValue, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel =  MovieListCollectionCellViewModel(movieList: listItem[indexPath.row])
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
        let height = width * 1.6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: MovieScreensConstant.videoURL.videoURL.rawValue) {
            if let titleData = listItem[indexPath.row].originalTitle {
                delegate?.videoTapped(url: url, title: titleData)
            }else{
                delegate?.videoTapped(url: url, title: MovieScreensConstant.MovieListConstant.unknown.rawValue)
            }
        }
    }
}
