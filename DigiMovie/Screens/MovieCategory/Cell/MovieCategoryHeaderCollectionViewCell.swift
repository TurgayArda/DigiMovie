//
//  MovieCategoryHeaderCollectionViewCell.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import UIKit

protocol MovieCategoryHeaderURL {
    func videoInfo(url: URL, title: String)
}

class MovieCategoryHeaderCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    
    private lazy var movieCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MovieCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCategoryCollectionViewCell.Identifier.path.rawValue
        )
        
        return collectionView
    }()
    
    var delegate: MovieCategoryHeaderURL?
    var provider = MovieCategoryCollectionProvider()
    
    enum Identifier: String {
        case path = "Cell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.backgroundColor = .black
        provider.delegate = self
        movieCategoryCollectionView.delegate = provider
        movieCategoryCollectionView.dataSource = provider
        contentView.addSubview(movieCategoryCollectionView)
        makeConstraints()
    }
    
    func saveModel(value: [MovieListResult]) {
        provider.load(value: value)
    }
}

extension MovieCategoryHeaderCollectionViewCell: MovieCategoryCollectionProviderDelegate {
    func videoTapped(url: URL, title: String) {
        delegate?.videoInfo(url: url, title: title)
    }
    func getWidth() -> CGFloat {
        return contentView.frame.size.width
    }
}

//MARK: - Constraints

extension MovieCategoryHeaderCollectionViewCell {
    private func makeConstraints() {
        movieCategoryCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
    }
}

