//
//  MovieDetailsViewControllerDelegate.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import UIKit
import SDWebImage

 
protocol MovieDetailsViewControllerDelegate: AnyObject {
    func viewWillDisappear()
}

class MovieDetailsViewController: UIViewController {
    
    weak var delegate: MovieDetailsViewControllerDelegate?
    
    private let movieImageView = UIImageView()
    private let movieNameLabel = UILabel()
    private let moviePopularityLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    private var movie: Movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureFavoriteButton()
        configureMovieNameLabel()
        configureMoviePopularityLabel()
        configureMovieImageView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.viewWillDisappear()
    }
    
    init(movie: Movie) {
        self.movie = movie
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func configureFavoriteButton() {
        view.addSubview(favoriteButton)
        
        if RealmManager.shared.isMovieInFavorites(movieID: movie.id) {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        favoriteButton.tintColor = .red
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }
    }
    
    private func configureMovieNameLabel() {
        view.addSubview(movieNameLabel)
        
        movieNameLabel.textColor = .white
        movieNameLabel.font = .boldSystemFont(ofSize: 20)
        movieNameLabel.text = movie.title
        movieNameLabel.textAlignment = .left
        
        movieNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
        }
    }
    
    private func configureMoviePopularityLabel() {
        view.addSubview(moviePopularityLabel)
        
        moviePopularityLabel.textColor = .white
        moviePopularityLabel.font = .boldSystemFont(ofSize: 20)
        moviePopularityLabel.text = "Popularity: \(movie.popularity)"
        moviePopularityLabel.textAlignment = .left
        
        moviePopularityLabel.snp.makeConstraints { make in
            make.top.equalTo(movieNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
        }
    }
    
    private func configureMovieImageView() {
        view.addSubview(movieImageView)
        
        movieImageView.layer.cornerRadius = 8
        movieImageView.clipsToBounds = true
        movieImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)"))
        
        movieImageView.snp.makeConstraints { make in
            make.top.equalTo(moviePopularityLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(400)
        }
    }
    
    //MARK: - Actions
    
    @objc private func favoriteButtonAction() {
        if favoriteButton.currentImage == UIImage(systemName: "heart") {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            RealmManager.shared.addToFavorites(movie: movie)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            RealmManager.shared.removeFromFavorites(movie: movie)
        }
    }
}
