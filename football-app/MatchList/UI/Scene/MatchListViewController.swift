//
//  MatchListViewController.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import UIKit
import Combine
import SnapKit
import AVKit
import AVFoundation

class MatchListViewController: ViewController {
    var viewModel: MatchListViewModel!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.backgroundColor = UIColor.white
            config.headerMode = .supplementary
            config.showsSeparators = false
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    
    private var dataSource: UICollectionViewDiffableDataSource<Date, Match>!
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Life-cycle

extension MatchListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        fetchData()
    }
}

// MARK: - Setup

extension MatchListViewController {
    func setup() {
        setTitle(viewModel.title)
        setupLayout()
        setupCollectionView()
        configureDataSource()
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicationView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        activityIndicationView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(
            MatchListHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MatchListHeader.reuseIdentifier
        )
        collectionView.register(
            MatchListCell.self,
            forCellWithReuseIdentifier: MatchListCell.reuseIdentifier
        )
    }
}

// MARK: - Bindings

private extension MatchListViewController {
    func bind() {
        viewModel.$groupedMatches
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.applySnapshot()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.showLoading()
                case .finishedLoading:
                    self.hideLoading()
                case .error(let error):
                    self.hideLoading()
                    self.showError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$matchHighlights
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                guard let self = self else { return }
                self.showHighlightVideo(url: url)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

private extension MatchListViewController {
    func showLoading() {
        collectionView.isUserInteractionEnabled = false
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func hideLoading() {
        collectionView.isUserInteractionEnabled = true
        activityIndicationView.stopAnimating()
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Fetch data

private extension MatchListViewController {
    func fetchData() {
        viewModel.fetchData()
    }
}

// MARK: - UICollectionViewDataSource

extension MatchListViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Date, Match>(collectionView: collectionView) { [weak self] collectionView, indexPath, match in
            guard let self = self else {
                fatalError()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchListCell.reuseIdentifier, for: indexPath) as! MatchListCell
            cell.viewModel = self.viewModel.getMatchCellViewModel(match)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else {
                fatalError()
            }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MatchListHeader.reuseIdentifier,
                for: indexPath
            ) as! MatchListHeader
            header.viewModel = viewModel.getMatchHeaderViewModel(index: indexPath.section)
            return header
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Date, Match>()
        
        for groupedMatch in viewModel.groupedMatches {
            snapshot.appendSections([groupedMatch.date ?? Date()])
            snapshot.appendItems(groupedMatch.matches, toSection: groupedMatch.date)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Routers

private extension MatchListViewController {
    func showHighlightVideo(url: URL?) {
        guard let url = url else { return }
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) {
            vc.player?.play()
        }
    }
}
