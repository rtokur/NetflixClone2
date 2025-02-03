//
//  DetailVC.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 30.01.2025.
//

import UIKit
import SnapKit
import Kingfisher
class DetailVC: UIViewController {
    // MARK: - UI Elements
    let connection = Connection()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let view2 : UIView = {
        let view2 = UIView()
        view2.layer.cornerRadius = 8
        view2.clipsToBounds = true
        return view2
    }()
    
    
    let playButton : UIButton = {
        let playButton = UIButton()
        playButton.backgroundColor = .white.withAlphaComponent(0.9)
        playButton.setImage(UIImage(systemName: "play.fill"),for: UIControl.State.normal)
        playButton.tintColor = .black
        playButton.layer.cornerRadius = 8
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        return playButton
    }()
    
    let scrollView = UIScrollView()
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .fill
        return stackView
    }()
    
    let stackView2 : UIStackView = {
        let stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView2.distribution = .fill
        stackView2.spacing = 1
        stackView2.alignment = .fill
        return stackView2
    }()
    
    let dateLabel : UILabel = {
        let dateLabel = UILabel()
        dateLabel.numberOfLines = 1
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textAlignment = .left
        return dateLabel
    }()
    
    let playButton2 : UIButton = {
        let playButton2 = UIButton()
        playButton2.backgroundColor = .label
        playButton2.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        playButton2.tintColor = .systemBackground
        playButton2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        playButton2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        playButton2.setTitle("Play", for: .normal)
        playButton2.setTitleColor(.systemBackground, for: UIControl.State.normal)
        playButton2.layer.cornerRadius = 3
        return playButton2
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .label
        button.setTitle("Favorite", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    let descriptionLabel : UILabel = {
        let descriptionLabel  = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = .max
        return descriptionLabel
    }()
    
    let genresLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let runtimeLabel : UILabel = {
        let runtimeLabel = UILabel()
        runtimeLabel.numberOfLines = 1
        runtimeLabel.font = .systemFont(ofSize: 14)
        runtimeLabel.textAlignment = .left
        return runtimeLabel
    }()
    // MARK: - Empty Objects
    var movie : Movie?
    var serie : Serie?
    var detail : Detail?
    var genres : [Genre]?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        getData()
        // Do any additional setup after loading the view.
    }
    // MARK: - Make call for movie or serie detail from API
    func getData(){
        if let movieId = movie?.id {
            Task {
                detail = try await connection.getMovieDetail(movieId: movieId)
                let runtime = detail?.runtime ?? 0
                let hours = runtime / 60
                let minutes = runtime / 60 % 60
                runtimeLabel.text = "\(hours) hours \(minutes) minutes"
                if let genres2 = detail?.genres {
                    genres = genres2
                    var genresName : [String] = []
                    for i in 0..<(genres?.count ?? 0) {
                        genresName.append(genres?[i].name ?? "")
                    }
                    genresLabel.text = "\(genresName.joined(separator: " • "))"
                }
            }
        }
        else if let serieId = serie?.id {
            Task {
                detail = try await connection.getSerieDetail(serieId: serieId)
                if let numberOfSeasons = detail?.numberOfSeasons, numberOfSeasons != 1 {
                    runtimeLabel.text = "\(numberOfSeasons) Seasons"
                    if let genres2 = detail?.genres {
                        genres = genres2
                        var genresName : [String] = []
                        for i in 0..<(genres?.count ?? 0) {
                            genresName.append(genres?[i].name ?? "")
                        }
                        genresLabel.text = "\(genresName.joined(separator: " • "))"
                    }

                } else if let numberOfEpisodes = detail?.numberOfEpisodes {
                    runtimeLabel.text = "\(numberOfEpisodes) Episodes"
                    if let genres2 = detail?.genres {
                        genres = genres2
                        var genresName : [String] = []
                        for i in 0..<(genres?.count ?? 0) {
                            genresName.append(genres?[i].name ?? "")
                        }
                        genresLabel.text = "\(genresName.joined(separator: " • "))"
                    }
                    
                }
            }
        }
    }
    // MARK: - Setup Views
    func setupViews(){
        view.addSubview(scrollView)

        scrollView.addSubview(stackView)
        
        // ImageView's image setting
        if let posterPath = serie?.posterPath  {
            if let url = serie?.posterURL {
                self.imageView.kf.setImage(with: url)
            }
        }else if let posterPath = movie?.posterPath  {
            if let url = movie?.posterURL {
                self.imageView.kf.setImage(with: url)
            }
            
        }
        stackView.addArrangedSubview(imageView)
        
        view.addSubview(view2)

        view2.addSubview(playButton)
        
        // Title Label text setting
        if let title = movie?.title {
            titleLabel.text = title
        } else if let name = serie?.name {
            titleLabel.text = name
        }
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(genresLabel)
        
        stackView.addArrangedSubview(stackView2)
        
//      Setting datelabel text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let releaseDate = movie?.releaseDate , let release = dateFormatter.date(from: releaseDate){
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: release)
            dateLabel.text = year
        }else if let firstAirDate = serie?.firstAirDate, let firstAir = dateFormatter.date(from: firstAirDate){
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: firstAir)
            dateLabel.text = year
        }
        stackView2.addArrangedSubview(dateLabel)
        
        stackView2.addArrangedSubview(runtimeLabel)

        stackView.addArrangedSubview(playButton2)

        // Description Label Text setting
        if let overview = movie?.overview  {
            descriptionLabel.text = overview
        } else if let overview = serie?.overview {
            descriptionLabel.text = overview
        }
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.addArrangedSubview(favoriteButton)
        
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Play Button Action method
    @objc func playButtonAction(sender: UIButton) {
        print("play button tapped")
    }
    
    // MARK: - Setup Constraints
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(13)
            make.width.equalTo(scrollView).inset(13)
        }

        imageView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(230)
        }
        view2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.center.equalTo(imageView)
            make.width.equalTo(80)
        }
        playButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
 
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        genresLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        runtimeLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }

        playButton2.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(40)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(stackView).dividedBy(3)
        }
        
    }

}

