//
//  MovieListCollectionViewCell.swift
//  DigiMovie
//
//  Created by Arda Sisli on 3.11.2023.
//

import UIKit
import AVFoundation
import AVKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
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
    
    //MARK: - Properties
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var cellViewModel: MovieListCollectionCellViewModelProtocol?
    
    enum Identifier: String {
        case path = "Cell"
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    
    private func configure() {
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.addSubview(movieimage)
        contentView.addSubview(movieName)
        makeImage()
        makeName()
    }
    
    
    //    func playVideo(url: URL) {
    //           player = AVPlayer(url: url)
    //           playerLayer = AVPlayerLayer(player: player)
    //           playerLayer?.frame = bounds
    //           layer.addSublayer(playerLayer!)
    //           player?.play()
    //       }
    
    func playVideo() {
        if let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8") {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            layer.addSublayer(playerLayer!)
            layer.zPosition = 1
            player?.play()
        }
    }
    
    
    func stopVideo() {
        player?.pause()
    }
    
    private func propertyUI() {
        movieName.text = cellViewModel?.getItemName()
        if let url = URL(string: cellViewModel?.getImageURL() ?? "") {
            movieimage.kf.setImage(with: url)
        }
    }
    
    
    func saveModel(viewModel: MovieListCollectionCellViewModel) {
        self.cellViewModel = viewModel
        propertyUI()
    }
}

//MARK: - Constraints

extension MovieListCollectionViewCell {
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
