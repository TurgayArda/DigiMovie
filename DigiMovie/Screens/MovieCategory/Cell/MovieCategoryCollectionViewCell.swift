//
//  MovieCategoryCollectionViewCell.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import UIKit

class MovieCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    
    private lazy var movieimage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var movieName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .darkGray
        return label
    }()
    
    var cellViewModel: MovieCategoryCollectionCellViewModelProtocol?
    
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
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.addSubview(movieimage)
        contentView.addSubview(movieName)
        makeImage()
        makeName()
    }
    
    
    func propertyUI() {
        movieName.text = cellViewModel?.getItemName()
        if let url = URL(string: cellViewModel?.getImageURL() ?? "") {
            movieimage.kf.setImage(with: url)
        }
    }
    
    
    func saveModel(viewModel: MovieCategoryCollectionCellViewModel) {
        self.cellViewModel = viewModel
        propertyUI()
    }
}

//MARK: - Constraints

extension MovieCategoryCollectionViewCell {
    private func makeImage() {
        movieimage.snp.makeConstraints { make in
            make
                .top
                .equalTo(contentView)
            make
                .height
                .equalTo(contentView.frame.size.height * 0.9)
            make
                .width
                .equalTo(contentView.frame.size.width)
        }
    }
    
    private func makeName() {
        movieName.snp.makeConstraints { make in
            make.top.equalTo(movieimage.snp.bottom)
            make
                .left
                .right
                .bottom
                .equalTo(contentView)
        }
    }
}

