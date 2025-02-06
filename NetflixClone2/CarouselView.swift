//
//  CarouselView.swift
//  NetflixClone2
//
//  Created by Rumeysa Tokur on 5.02.2025.
//

import UIKit
import SnapKit

// MARK: - Protocol
protocol CarouselViewDelegate : AnyObject {
    func didSelectMovie(_ upcoming: Movie)
}

class CarouselView: UIView, UICollectionViewDelegate {
    // MARK: - Properties
    weak var delegate: CarouselViewDelegate?
    private var upcomingData : [Movie] = []
    private var currentPage = 0
    
    // MARK: - UI Elements
    lazy var upComingMovieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 366, height: 580)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    // MARK: - Initializers
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup Methods
    private func setupViews() {
        addSubview(upComingMovieCollectionView)
        addSubview(pageControl)
        upComingMovieCollectionView.register(UpComingMovieCollectionViewCell.self, forCellWithReuseIdentifier: "UpComingMovieCollectionViewCell")
        
        upComingMovieCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    // MARK: - Scroll View Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
    }
}

// MARK: - UICollectionViewDataSource
extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingMovieCollectionViewCell", for: indexPath) as! UpComingMovieCollectionViewCell
        
        let url = upcomingData[indexPath.row].posterURL
        print(url)
        cell.movie = upcomingData[indexPath.row]
        cell.configure(url: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let upcomingMovie = upcomingData[indexPath.row]
        delegate?.didSelectMovie(upcomingMovie)
    }
}
// MARK: - Update Method
extension CarouselView {
    public func configureView(with data: [Movie]) {
        self.upcomingData = data
        self.pageControl.numberOfPages = data.count
        upComingMovieCollectionView.reloadData()
    }
}
