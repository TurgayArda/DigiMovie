//
//  MovieCategoryVC.swift
//  DigiMovie
//
//  Created by Arda Sisli on 4.11.2023.
//

import UIKit

protocol MovieCategoryViewDelegate {
    func handleOutPut(_ output: MovieCategoryPresenterOutPut)
}

class MovieCategoryVC: UIViewController {
    
    //MARK: - Views
    
    private lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.text = MovieScreensConstant.MovieCategoryConstant.title.rawValue
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 21)
        return label
    }()
    
    private lazy var categorySegmentController: UISegmentedControl = {
        let segmented = UISegmentedControl(items: [MovieScreensConstant.MovieCategoryConstant.segmentOne.rawValue,
                                                   MovieScreensConstant.MovieCategoryConstant.segmentSecond.rawValue,
                                                   MovieScreensConstant.MovieCategoryConstant.segmentThird.rawValue])
        segmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmented.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmented.backgroundColor = .clear
        return segmented
    }()
    
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "arrowshape.left")
        imageView.image = image
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        return pageView
    }()
    
    var viewControllers: [UIViewController] = []
    let pageViewControllerContainer = UIView()
    
    //MARK: - Properties
    
    var categoryViewModel: MovieCategoryViewModelProtocol?
    var interactor: MovieCategoryInteractorProtocol?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.fetchMovie()
        initDelegate()
        setupPageViewController()
    }
    
    //MARK: - Private Func
    
    private func initDelegate() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .black
        view.addSubview(navigationView)
        view.addSubview(pageViewControllerContainer)
        navigationView.addSubview(navigationTitle)
        navigationView.addSubview(backButton)
        navigationView.addSubview(categorySegmentController)
        backButton.addSubview(buttonImageView)
        addChild(pageViewController)
        pageViewControllerContainer.addSubview(pageViewController.view)
        
        makeConstraints()
        buttonTapped()
        
    }
    
    private func buttonTapped() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        categorySegmentController.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        if selectedSegmentIndex < viewControllers.count {
            pageViewController.setViewControllers([viewControllers[selectedSegmentIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true)
    }
    
    func setupPageViewController() {
        var firstVC = UIViewController()
        pageViewController.view.frame = pageViewControllerContainer.bounds
        pageViewController.didMove(toParent: self)
        
        guard let viewModel = categoryViewModel else { return }
        
        let firstViewController = FirstPageBuilder.make(viewModel: viewModel)
        let secondViewController = SecondPageBuilder.make(viewModel: viewModel)
        let thirdViewController = ThirdPageBuilder.make(viewModel: viewModel)
        
        viewControllers = [firstViewController, secondViewController, thirdViewController]
        
        
        switch categoryViewModel?.getSegmentID() {
        case 0:
            firstVC = viewControllers[0]
        case 1:
            firstVC = viewControllers[1]
        default:
            firstVC = viewControllers[2]
        }
        
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        
    }
}

//MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension MovieCategoryVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        return previousIndex >= 0 ? viewControllers[previousIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        return nextIndex < viewControllers.count ? viewControllers[nextIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: visibleViewController) {
            categorySegmentController.selectedSegmentIndex = index
        }
    }
}

//MARK: - MovieCategoryViewDelegate

extension MovieCategoryVC: MovieCategoryViewDelegate {
    func handleOutPut(_ output: MovieCategoryPresenterOutPut) {
        switch output {
        case .categoryInfo(let viewModel):
            self.categoryViewModel = viewModel
            categorySegmentController.selectedSegmentIndex = viewModel.getSegmentID()
        }
    }
}

//MARK: - Constraints

extension MovieCategoryVC {
    private func makeConstraints() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
            make.height.equalTo(UIScreen.screenHeight * 0.13)
        }
        
        navigationTitle.snp.makeConstraints { make in
            make.top.equalTo(navigationView).offset(8)
            make.centerX.equalTo(view)
            make.centerY.equalTo(backButton)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(navigationView).offset(8)
            make.left.equalTo(navigationView).offset(8)
            make.height.equalTo(UIScreen.screenHeight * 0.04)
            make.width.equalTo(UIScreen.screenWidth * 0.06)
        }
        
        buttonImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backButton)
            make.centerY.equalTo(backButton)
            make.height.equalTo(UIScreen.screenHeight * 0.04)
            make.width.equalTo(UIScreen.screenWidth * 0.06)
        }
        
        categorySegmentController.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(UIScreen.screenWidth * 0.8)
            make.top.equalTo(navigationTitle.snp.bottom).offset(16)
        }
        
        pageViewControllerContainer.snp.makeConstraints { make in
            make.top.equalTo(categorySegmentController.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.left.right.equalTo(view)
        }
    }
}

extension UIViewController {
    func index() -> Int {
        return (parent as! MovieCategoryVC).viewControllers.firstIndex(of: self) ?? 0
    }
}
