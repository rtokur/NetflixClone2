//
//  UpComingMovieCollectionViewCell.swift
//  NetflixClone2
//
//  Created by Rumeysa Tokur on 1.02.2025.
//

import UIKit
import SnapKit
class UpComingMovieCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    let view : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let playButton : UIButton = {
        let playButton = UIButton()
        playButton.backgroundColor = .white
        playButton.setImage(UIImage(systemName: "play.fill"),for: UIControl.State.normal)
        playButton.setTitle("Play", for: UIControl.State.normal)
        playButton.tintColor = .black
        playButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        playButton.setTitleColor(.black, for: UIControl.State.normal)
        playButton.layer.cornerRadius = 3
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        playButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return playButton
    }()
    
    let favoriteButton : UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.backgroundColor = .darkGray.withAlphaComponent(0.4)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
        favoriteButton.setTitle("Favorites", for: UIControl.State.normal)
        favoriteButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        favoriteButton.tintColor = .white
        favoriteButton.layer.cornerRadius = 3
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        favoriteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return favoriteButton
    }()
    
    let stackView3 : UIStackView = {
        let stackView3 = UIStackView()
        stackView3.axis = .horizontal
        stackView3.spacing = 13
        stackView3.alignment = .fill
        stackView3.distribution = .fillEqually
        return stackView3
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(imageView)
        
        contentView.addSubview(view)
        
        view.addSubview(stackView3)
        
        // MARK: - Play Button
        stackView3.addArrangedSubview(playButton)
        
        // MARK: - Favorite Button
        stackView3.addArrangedSubview(favoriteButton)
    }
    
    // MARK: - Favorite Button Action method
    @objc func favoriteButtonAction(sender: UIButton!) {
        print("favoritebuttontapped")
    }
    // MARK: - Play Button Action method
    @objc func playButtonAction(sender: UIButton!) {
        print("playbuttontapped")
    }
    // MARK: - Setup Constraints
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerX.equalTo(imageView.snp.centerX)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        stackView3.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        playButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
}

