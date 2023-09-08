//
//  MoviewFooter.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import UIKit


class MovieFooter: UICollectionReusableView {
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .black
        
        configureActivityIndicatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public
    
    func hideAIV() {
        activityIndicatorView.stopAnimating()
    }
    
    func startAIV() {
        activityIndicatorView.startAnimating()
    }
    
    //MARK: - Private
    
    private func configureActivityIndicatorView() {
        addSubview(activityIndicatorView)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.color = .white
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
