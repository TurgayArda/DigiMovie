//
//  FirstPageVC.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import UIKit
import AVKit
import AVFoundation

class FirstPageVC: UIViewController {
    
    //MARK: - Views
    
    private lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.isScrollEnabled = true
        collectionView.register(
            MovieCategoryHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCategoryHeaderCollectionViewCell.Identifier.path.rawValue
        )
        collectionView.register(MovieCategoryCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MovieCategoryCollectionReusableView.identifier
        )
        
        return collectionView
    }()
    
    private lazy var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Properties
    
    private var provider = MovieCategoryHeaderProvider()
    private var playerViewController: AVPlayerViewController!
    private var player: AVPlayer!
    
    var categoryViewModel: MovieCategoryViewModelProtocol?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegate()
    }
    
    //MARK: - Private Func
    
    private func initDelegate() {
        movieCollectionView.delegate = provider
        movieCollectionView.dataSource = provider
        provider.delegate = self
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .black
        view.addSubview(movieCollectionView)
        
        makeConstraints()
        updateProvider()
    }
    
    private func updateProvider() {
        if let viewModel = categoryViewModel {
            provider.update(viewModel: viewModel)
        }
    }
}

//MARK: - MovieCategoryHeaderProviderDelegate

extension FirstPageVC: MovieCategoryHeaderProviderDelegate {
    func videoTapped(url: URL, title: String) {
        player = AVPlayer(url: url)
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            self.player.play()
            self.videoTitleLabel.text = title
            
            if let contentOverlayView = self.playerViewController.contentOverlayView {
                contentOverlayView.addSubview(self.videoTitleLabel)
                self.videoTitleLabel.snp.makeConstraints { make in
                    make.left.equalTo(contentOverlayView).offset(32)
                    make.bottom.equalTo(contentOverlayView).offset(-88)
                }
            }
        }
    }
    
    func getWidth() -> CGFloat {
        return UIScreen.screenWidth
    }
}

//MARK: - Constraints

extension FirstPageVC {
    private func makeConstraints() {
        movieCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
        }
    }
}
