//
//  MovieCollectionViewCell.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import UIKit
import SDWebImage


class MovieCollectionViewCell: UICollectionViewCell {
    
    private let movieImageView = UIImageView()
    private let movieNameLabel = UILabel()
    private let moviePopularityLabel = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .darkGray
        layer.cornerRadius = 8
        
        configureMovieImageView()
        configureMovieNameLabel()
        configureMoviePopularityLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public
    
    func setupWithData(_ movieName: String, popularity: Double, imagePath: String) {
        movieNameLabel.text = movieName
        moviePopularityLabel.text = "Popularity: \(popularity)"
        movieImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/\(imagePath)"))
    }
    
    //MARK: - Private
    
    private func configureMovieImageView() {
        addSubview(movieImageView)
        
        movieImageView.layer.cornerRadius = 8
        movieImageView.clipsToBounds = true
        
        movieImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(64)
        }
    }
    
    private func configureMovieNameLabel() {
        addSubview(movieNameLabel)
        
        movieNameLabel.textColor = .white
        movieNameLabel.font = .systemFont(ofSize: 18)
        movieNameLabel.textAlignment = .left
        
        movieNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(movieImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    private func configureMoviePopularityLabel() {
        addSubview(moviePopularityLabel)
        
        moviePopularityLabel.textColor = .white
        moviePopularityLabel.font = .systemFont(ofSize: 18)
        moviePopularityLabel.textAlignment = .left
        
        moviePopularityLabel.snp.makeConstraints { make in
            make.top.equalTo(movieNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(movieImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            
        }
    }
}
