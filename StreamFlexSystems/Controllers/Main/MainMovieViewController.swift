//
//  MainMovieViewController.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import UIKit
import SnapKit


enum Segment: Int {
    case popularity = 0
    case onAir = 1
    case favorites = 2
}

class MainMoviewViewController: UIViewController {
    
    private let cellId = "cellId"
    private let footerId = "footerId"
    private var currentLoadedPage = 1
    private var isPaginating = false
    private let segmentItems = ["Popularity", "On Air", "Favorites"]
    
    private let topLabel = UILabel()
    private let moviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let filterLabel = UILabel()
    private lazy var segmentedControl = UISegmentedControl(items: segmentItems)
    
    private var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPopularMovies()
                
        view.backgroundColor = .black
        
        configureTopLabel()
        configureFilterLabel()
        configureSegmentedControl()
        configureMoviesCollectionView()
    }
    
    //MARK: - Private
    
    private func fetchPopularMovies() {
        Network.shared.fetchAllPopularMovies(page: currentLoadedPage) {[weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Oops", message: error.localizedDescription, actionTitle: "OK")
                }
            }
            if let result = result {
                DispatchQueue.main.async {
                    self?.movies = result.results
                    self?.movies.sort { $0.popularity > $1.popularity }
                    self?.moviesCollectionView.reloadData()
                }
            }
        }
    }
    
    private func fetchOnAirMovies() {
        Network.shared.fetchMoviesOnAir(page: currentLoadedPage) {[weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Oops", message: error.localizedDescription, actionTitle: "OK")
                }
            }
            if let result = result {
                DispatchQueue.main.async {
                    self?.movies = result.results
                    self?.moviesCollectionView.reloadData()
                }
            }
        }
    }
    
    private func fetchFavoriteMovies() {
        let favoriteMovies = RealmManager.shared.getFavoritesMovies()
        DispatchQueue.main.async {[weak self] in
            self?.movies = favoriteMovies
            self?.moviesCollectionView.reloadData()
        }
    }
    
    private func configureTopLabel() {
        view.addSubview(topLabel)
        
        topLabel.text = "Movies"
        topLabel.font = .boldSystemFont(ofSize: 18)
        topLabel.textColor = .white
        
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureFilterLabel() {
        view.addSubview(filterLabel)
        
        filterLabel.text = "Filter by:"
        filterLabel.font = .boldSystemFont(ofSize: 18)
        filterLabel.textColor = .white
        
        filterLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .darkGray
        segmentedControl.selectedSegmentTintColor = .lightGray
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.leading.equalTo(filterLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(28)
        }
    }
    
    private func configureMoviesCollectionView() {
        view.addSubview(moviesCollectionView)
        
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        moviesCollectionView.register(MovieFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        moviesCollectionView.backgroundColor = .clear
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.showsVerticalScrollIndicator = false
        
        moviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Actions
    
    @objc private func segmentedControlAction() {
        currentLoadedPage = 1
        switch Segment(rawValue: segmentedControl.selectedSegmentIndex) {
        case .popularity:
            fetchPopularMovies()
        case .onAir:
            fetchOnAirMovies()
        case .favorites:
            fetchFavoriteMovies()
        default:
            break
        }
    }
}

//MARK: - UICollectionViewDataSource

extension MainMoviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell()}
        
        let movie = movies[indexPath.item]
        
        cell.setupWithData(movie.title, popularity: movie.popularity, imagePath: movie.posterPath)
        
        if indexPath.item == movies.count - 1 && !isPaginating {
            self.isPaginating = true
            currentLoadedPage += 1
            switch Segment(rawValue: segmentedControl.selectedSegmentIndex) {
            case .popularity:
                Network.shared.fetchAllPopularMovies(page: currentLoadedPage) {[weak self] result, error in
                    sleep(2)
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Oops", message: error.localizedDescription, actionTitle: "OK")
                        }
                    }
                    
                    if let result = result {
                        DispatchQueue.main.async {
                            self?.movies += result.results
                            self?.moviesCollectionView.reloadData()
                        }
                    }
                }
            case .onAir:
                Network.shared.fetchMoviesOnAir(page: currentLoadedPage) {[weak self] result, error in
                    sleep(2)
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Oops", message: error.localizedDescription, actionTitle: "OK")
                        }
                    }
                    
                    if let result = result {
                        DispatchQueue.main.async {
                            self?.movies += result.results
                            self?.moviesCollectionView.reloadData()
                        }
                    }
                }
            default:
                break
            }
            isPaginating = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsController = MovieDetailsViewController(movie: movies[indexPath.item])
        movieDetailsController.delegate = self
        navigationController?.pushViewController(movieDetailsController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as? MovieFooter else { return UICollectionReusableView() }

        switch Segment(rawValue: segmentedControl.selectedSegmentIndex) {
        case .favorites:
            footer.hideAIV()
        default:
            footer.startAIV()
        }

        return footer
    }
}

//MARK: - UICollectionViewDataSource

extension MainMoviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

//MARK: - MovieDetailsViewControllerDelegate

extension MainMoviewViewController: MovieDetailsViewControllerDelegate {
    func viewWillDisappear() {
        switch Segment(rawValue: segmentedControl.selectedSegmentIndex) {
        case .favorites:
            fetchFavoriteMovies()
        default:
            break
        }
    }
}
