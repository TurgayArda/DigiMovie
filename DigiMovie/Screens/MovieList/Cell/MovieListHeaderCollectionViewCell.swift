//
//  MovieListCollectionViewCell.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import UIKit
import Kingfisher
import AVKit
import AVFoundation

protocol MovieListHeaderURL {
    func videoInfo(url: URL, title: String)
}

class MovieListHeaderCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    
    private lazy var movieListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MovieListCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieListCollectionViewCell.Identifier.path.rawValue
        )
        
        return collectionView
    }()
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var provider = MovieListCollectionProvider()
    var delegate: MovieListHeaderURL?
    var url: URL?
    
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
        movieListCollectionView.delegate = provider
        movieListCollectionView.dataSource = provider
        contentView.addSubview(movieListCollectionView)
        makeConstraints()
    }
    
    func saveModel(value: [MovieListResult]) {
        provider.load(value: value)
    }
}

extension MovieListHeaderCollectionViewCell: MovieListCollectionProviderDelegate {
    func videoTapped(url: URL, title: String) {
        delegate?.videoInfo(url: url, title: title)
    }
    
    func getWidth() -> CGFloat {
        return contentView.frame.size.width
    }
}

//MARK: - Constraints

extension MovieListHeaderCollectionViewCell {
    private func makeConstraints() {
        movieListCollectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }
}
