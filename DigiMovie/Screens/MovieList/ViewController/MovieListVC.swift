//
//  MovieListVC.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import UIKit
import SnapKit
import AVKit
import AVFoundation

protocol MovieListViewDelegate {
    func handleOutPut(_ output: MovieListPresenterOutPut)
    func movieHandleOutPut(_ output: MoviePresenterOutPut)
}

class MovieListVC: UIViewController {
    
    //MARK: - Views
    
    private lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.isScrollEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(
            MovieImageCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieImageCollectionViewCell.Identifier.path.rawValue
        )
        
        collectionView.register(
            MovieListHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieListHeaderCollectionViewCell.Identifier.path.rawValue
        )
        
        
        
        collectionView.register(MovieListHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MovieListHeaderCollectionReusableView.identifier
        )
        
        return collectionView
    }()
    
    private lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.text = MovieScreensConstant.MovieListConstant.title.rawValue
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 21)
        return label
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private var categoryButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var foreignButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(MovieScreensConstant.MovieListConstant.foreignButton.rawValue, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    private var domesticButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(MovieScreensConstant.MovieListConstant.domesticButton.rawValue, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    private var depictionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(MovieScreensConstant.MovieListConstant.depictionButton.rawValue, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
    
    private var movieListHeaderProvider = MovieListHeaderProvider()
    private var playerViewController: AVPlayerViewController!
    private var player: AVPlayer!
    private var isLoading = true
    
    var router: MovieListRouterProtocol?
    var interactor: MovieListInteractorProtocol?
    var viewModel: MovieListViewModelProtocol?
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.fechMovieGenre()
        activityIndicator.startAnimating()
        initDelegate()
    }
    
    
    //MARK: - Private Func
    
    
    private func initDelegate() {
        movieCollectionView.delegate = movieListHeaderProvider
        movieCollectionView.dataSource = movieListHeaderProvider
        movieListHeaderProvider.delegate = self
        
        configure()
    }
    
    private func configure()  {
        view.backgroundColor = .black
        view.addSubview(movieCollectionView)
        view.addSubview(navigationView)
        view.addSubview(activityIndicator)
        navigationView.addSubview(navigationTitle)
        navigationView.addSubview(categoryStackView)
        categoryStackView.addArrangedSubview(categoryButtonView)
        categoryStackView.addArrangedSubview(foreignButton)
        categoryStackView.addArrangedSubview(domesticButton)
        categoryStackView.addArrangedSubview(depictionButton)
        view.bringSubviewToFront(navigationView)
        view.bringSubviewToFront(activityIndicator)
        
        makeConstraints()
        buttonTapped()
        LoadingIndicator()
        
    }
    
    private func buttonTapped() {
        foreignButton.addTarget(self, action: #selector(didTapForeignButton), for: .touchUpInside)
        domesticButton.addTarget(self, action: #selector(didTapDomesticButton), for: .touchUpInside)
        depictionButton.addTarget(self, action: #selector(didTapDepictionButton), for: .touchUpInside)
    }
    
    @objc func didTapForeignButton() {
        handleButtonTap(id: 0)
    }
    
    @objc func didTapDomesticButton() {
        handleButtonTap(id: 1)
    }
    
    @objc func didTapDepictionButton() {
        handleButtonTap(id: 2)
    }
    
    func handleButtonTap(id: Int) {
        if let viewModel = viewModel {
            router?.navigate(id: id, title: viewModel.getGenreName(), MovieList: viewModel.getMovieList())
        }
    }
    
    func LoadingIndicator() {
        DispatchQueue.main.async {
            if self.isLoading {
                self.navigationView.isHidden = true
                self.activityIndicator.startAnimating()
            }else{
                self.navigationView.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

//MARK: - MovieListHeaderProviderDelegate

extension MovieListVC: MovieListHeaderProviderDelegate {
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
        return view.frame.size.width
    }
}

//MARK: - MovieListViewDelegate

extension MovieListVC: MovieListViewDelegate {
    func movieHandleOutPut(_ output: MoviePresenterOutPut) {
        switch output {
        case .movieList(let viewModel):
            self.viewModel = viewModel
            self.movieListHeaderProvider.update(with: viewModel)
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        case .error(let error):
            self.showAlert(error: error, actionTitle: "OK")
        case .isLoading(let isLoading):
            self.isLoading = isLoading
            self.LoadingIndicator()
        }
    }
    
    func handleOutPut(_ output: MovieListPresenterOutPut) {
        switch output {
        case .error(let error):
            self.showAlert(error: error, actionTitle: "OK")
        }
    }
}

//MARK: - Constraints

extension MovieListVC {
    private func makeConstraints() {
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
            make.height.equalTo(UIScreen.screenHeight * 0.13)
        }
        
        navigationTitle.snp.makeConstraints { make in
            make.top.equalTo(navigationView).offset(8)
            make.centerX.equalTo(view)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(navigationTitle.snp.bottom).offset(8)
            make.bottom.equalTo(navigationView)
            make.centerX.equalTo(view)
            make.width.equalTo(UIScreen.screenWidth * 0.8)
        }
        
        foreignButton.snp.makeConstraints { make in
            make.width.equalTo(categoryStackView.snp.width).multipliedBy(0.3)
        }
        
        domesticButton.snp.makeConstraints { make in
            make.width.equalTo(categoryStackView.snp.width).multipliedBy(0.4)
        }
        
        depictionButton.snp.makeConstraints { make in
            make.width.equalTo(categoryStackView.snp.width).multipliedBy(0.3)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
    }
}
