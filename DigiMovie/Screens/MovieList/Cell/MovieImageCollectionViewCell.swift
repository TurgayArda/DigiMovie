//
//  MovieImageCollectionViewCell.swift
//  DigiMovie
//
//  Created by Arda Sisli on 3.11.2023.
//

import UIKit

class MovieImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    
    private lazy var movieImagescrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .black
        return scroll
    }()
    
    private lazy var moviePage: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.translatesAutoresizingMaskIntoConstraints = false
        page.pageIndicatorTintColor = UIColor.black
        page.currentPageIndicatorTintColor = UIColor.white
        return page
    }()
    
    //MARK: - Properties
    
    private var previousImageView: UIImageView?
    
    
    enum Identifier: String {
        case path = "CellImage"
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Func
    
    private func initDelegate() {
        movieImagescrollView.delegate = self
        
        configure()
        
    }
    
    private func configure() {
        contentView.backgroundColor = .black
        contentView.addSubview(movieImagescrollView)
        contentView.addSubview(moviePage)
        
        makeConstraints()
    }
    
    private func scrollImage(movieImage: [String]) {
        for i in 0..<movieImage.count {
            let imageView = UIImageView()
            if let url = URL(string: MovieScreensConstant.MovieImage.movieURL(posterPath: movieImage[i])) {
                imageView.kf.setImage(with: url)
            }
            
            moviePage.numberOfPages = movieImage.count
            movieImagescrollView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.width.equalTo(contentView)
                make.height.equalTo(movieImagescrollView)
                make.top.equalTo(movieImagescrollView.snp.top)
                if let previousView = previousImageView {
                    make.left.equalTo(previousView.snp.right)
                } else {
                    make.left.equalToSuperview()
                }
                if i == movieImage.count {
                    make.right.equalToSuperview()
                }
            }
            
            previousImageView = imageView
        }
        
        movieImagescrollView.contentSize = CGSize(width: contentView.frame.size.width * CGFloat(movieImage.count), height: 0)
    }
    
    func saveModel(value: [String]) {
        scrollImage(movieImage: value)
    }
    
}

//MARK: - UIScrollViewDelegate

extension MovieImageCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        moviePage.currentPage = Int(pageNumber)
    }
}

//MARK: - Constraints

extension MovieImageCollectionViewCell {
    func makeConstraints() {
        movieImagescrollView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(contentView)
        }
        
        moviePage.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.width.equalTo(UIScreen.screenWidth * 0.6)
            make.bottom.equalTo(movieImagescrollView.snp.bottom).offset(-8)
        }
    }
}

