//
//  MovieListHeaderProvider.swift
//  DigiMovie
//
//  Created by Arda Sisli on 3.11.2023.
//

import UIKit

protocol MovieListHeaderProviderProtocol {
    var delegate: MovieListHeaderProviderDelegate? { get set }
    func update(with viewmodel: MovieListViewModelProtocol)
}

protocol MovieListHeaderProviderDelegate {
    func getWidth() -> CGFloat
    func videoTapped(url: URL, title: String)
}

class MovieListHeaderProvider: NSObject {
    
    var delegate: MovieListHeaderProviderDelegate?
    var listItem = [String: [MovieListResult]]()
    var listTitle: [String] = []
    var movieImage: [String] = []
}

//MARK: - MovieListHeaderProviderProtocol

extension MovieListHeaderProvider: MovieListHeaderProviderProtocol {    
    func update(with viewmodel: MovieListViewModelProtocol) {
        self.listItem = viewmodel.getMovieList()
        self.listTitle = viewmodel.getGenreName()
        self.movieImage = viewmodel.getMovieImage()
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MovieListHeaderURL

extension MovieListHeaderProvider: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MovieListHeaderURL {
    func videoInfo(url: URL, title: String) {
        delegate?.videoTapped(url: url, title: title)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listTitle.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieImageCollectionViewCell.Identifier.path.rawValue, for: indexPath) as? MovieImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.saveModel(value: movieImage)
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListHeaderCollectionViewCell.Identifier.path.rawValue, for: indexPath) as? MovieListHeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            guard let data = listItem[listTitle[indexPath.section - 1]] else { return cell }
            cell.saveModel(value: data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: MovieListHeaderCollectionReusableView.identifier,
                                                                         for: indexPath) as! MovieListHeaderCollectionReusableView
            
            header.titleLabel.text = ""
            
            return header
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: MovieListHeaderCollectionReusableView.identifier,
                                                                         for: indexPath) as! MovieListHeaderCollectionReusableView
            header.titleLabel.text = listTitle[indexPath.section - 1]
            
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let width = delegate?.getWidth() else { return CGSize(width: 30, height: 30) }
        switch section {
        case 0:
            return CGSize(width: 0,
                          height: 0)
        default:
            return CGSize(width: width,
                          height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var padding = 0.0
        
        switch section {
        case 0:
            padding = 0
        default:
            padding = 10
        }
        
        return UIEdgeInsets(top: padding, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        switch indexPath.section {
        case 0:
            let height = width
            return CGSize(width: width, height: height)
        default:
            let height = width * 0.55
            return CGSize(width: width, height: height)
            
        }
    }
}
