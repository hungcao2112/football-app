//
//  TeamListViewController.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import UIKit
import Combine

class TeamListViewController: ViewController {
    var viewModel: TeamListViewModel!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.backgroundColor = UIColor.white
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            return section
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    
    private var dataSource: UICollectionViewDiffableDataSource<TeamListViewModel.TeamSection, Team>!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
}

// MARK: - Setup

private extension TeamListViewController {
    func setup() {
        setTitle(viewModel.title)
        setupNavigationBarItems()
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
        collectionView.delegate = self
        collectionView.register(
            TeamListCell.self,
            forCellWithReuseIdentifier: TeamListCell.reuseIdentifier
        )
    }
    
    func setupNavigationBarItems() {
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        let submitButton = UIBarButtonItem(
            title: "Submit",
            style: .plain,
            target: self,
            action: #selector(onSubmitTapped)
        )
        
        closeButton.tintColor = .black
        submitButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = submitButton
    }
}

// MARK: - Bindings

private extension TeamListViewController {
    func bind() {
        viewModel.$teams
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.applySnapshot()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

extension TeamListViewController {
    @objc
    func onSubmitTapped() {
        viewModel.handleSubmitTeamSelected()
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TeamListViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TeamListViewModel.TeamSection, Team>(collectionView: collectionView) { [weak self] collectionView, indexPath, team in
            guard let self = self else {
                fatalError()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamListCell.reuseIdentifier, for: indexPath) as! TeamListCell
            cell.viewModel = self.viewModel.getTeamListCellViewModel(team)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TeamListViewModel.TeamSection, Team>()
        snapshot.appendSections([.teams])
        snapshot.appendItems(viewModel.teams, toSection: .teams)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension TeamListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.handleSelectTeam(at: indexPath.item)
    }
}
