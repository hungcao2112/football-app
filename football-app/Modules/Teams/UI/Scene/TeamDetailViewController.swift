//
//  TeamDetailViewController.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import UIKit
import Combine

class TeamDetailViewController: ViewController {
    var viewModel: TeamDetailViewModel!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.backgroundColor = UIColor.white
            config.headerMode = .supplementary
            config.showsSeparators = false
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
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
    
    private var dataSource: UICollectionViewDiffableDataSource<TeamDetailViewModel.Section, Match>!
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Life-cycle

extension TeamDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        fetchData()
    }
}

// MARK: - Setup

extension TeamDetailViewController {
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
            TeamDetailHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TeamDetailHeaderView.reuseIdentifier
        )
        collectionView.register(
            TeamDetailCell.self,
            forCellWithReuseIdentifier: TeamDetailCell.reuseIdentifier
        )
    }
}

// MARK: - Bindings

private extension TeamDetailViewController {
    func bind() {
        viewModel.$matches
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.applySnapshot()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Fetch data

private extension TeamDetailViewController {
    func fetchData() {
        viewModel.fetchData()
    }
}

// MARK: - UICollectionViewDataSource

extension TeamDetailViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TeamDetailViewModel.Section, Match>(collectionView: collectionView) { [weak self] collectionView, indexPath, match in
            guard let self = self else {
                fatalError()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamDetailCell.reuseIdentifier, for: indexPath) as! TeamDetailCell
            cell.viewModel = self.viewModel.getTeamDetailCellViewModel(match: match)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else {
                fatalError()
            }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TeamDetailHeaderView.reuseIdentifier,
                for: indexPath
            ) as! TeamDetailHeaderView
            header.viewModel = viewModel.getTeamDetailHeaderViewModel()
            return header
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TeamDetailViewModel.Section, Match>()
        snapshot.appendSections([.matches])
        snapshot.appendItems(viewModel.matches, toSection: .matches)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
