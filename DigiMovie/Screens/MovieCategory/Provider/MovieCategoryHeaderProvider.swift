//
//  MovieCategoryProvider.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.

import UIKit

protocol MovieCategoryHeaderProviderProtocol {
    var delegate: MovieCategoryHeaderProviderDelegate? { get set }
    func update(viewModel: MovieCategoryViewModelProtocol, isPage: Bool?)
}

protocol MovieCategoryHeaderProviderDelegate {
    func getWidth() -> CGFloat
    func videoTapped(url: URL, title: String)
}

class MovieCategoryHeaderProvider: NSObject {
    
    var delegate: MovieCategoryHeaderProviderDelegate?
    var listItem = [String: [MovieListResult]]()
    var listTitle: [String] = []
}

//MARK: - MovieListHeaderProviderProtocol

extension MovieCategoryHeaderProvider: MovieCategoryHeaderProviderProtocol {
    func update(viewModel: MovieCategoryViewModelProtocol, isPage: Bool? = false) {
        if isPage  ?? false{
            self.listItem = viewModel.reverseDictionary()
            self.listTitle = viewModel.reverseGenreName()
        }else{
            self.listItem = viewModel.getMovieList()
            self.listTitle = viewModel.getGenreName()
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MovieCategoryHeaderProvider: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MovieCategoryHeaderURL {
    func videoInfo(url: URL, title: String) {
        delegate?.videoTapped(url: url, title: title)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCategoryHeaderCollectionViewCell.Identifier.path.rawValue, for: indexPath) as? MovieCategoryHeaderCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        guard let data = listItem[listTitle[indexPath.section]] else { return cell }
        cell.saveModel(value: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: MovieCategoryCollectionReusableView.identifier,
                                                                     for: indexPath) as! MovieCategoryCollectionReusableView
        header.titleLabel.text = listTitle[indexPath.section]
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let width = delegate?.getWidth() else { return CGSize(width: 30, height: 30) }
        
        return CGSize(width: width,
                      height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let with = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let width = (with)
        let height = width * 0.5
        return CGSize(width: width, height: height)
    }
}
